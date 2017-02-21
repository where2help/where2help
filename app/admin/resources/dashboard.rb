ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ I18n.t(".active_admin.dashboard")}, url: "/admin", html_options: { "data-turbolinks": "false" }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel I18n.t("active_admin.statistics.helper_statistics") do
          h4 I18n.t("active_admin.statistics.event_count")
          h2 do
            strong StatisticOperation::EventCount::Show.new.()
          end

          h4 I18n.t("active_admin.statistics.participants_upcoming")
          h2 do
            strong StatisticOperation::TotalParticipants::Upcoming.new.()
          end

          h4 I18n.t("active_admin.statistics.participants_past")
          h2 do
            strong StatisticOperation::TotalParticipants::Past.new.()
          end

          h4 I18n.t("active_admin.statistics.volunteers_needed")
          h2 do
            strong StatisticOperation::RequiredVolunteers::Show.new.()
          end

          h4 I18n.t("active_admin.statistics.work_hours")
          h2 do
            strong StatisticOperation::VolunteerWorkHours::Show.new.()
          end
        end
      end
    end
  end


  page_action :date_filtered, method: :post do
    from_date = Date.parse(params[:from_date])
    to_date = Date.parse(params[:to_date])

    volunteers_needed = Shift.unscoped.where("starts_at BETWEEN :from and :to", from: from_date, to: to_date).sum(:volunteers_needed)
    volunteers_count = (Shift.unscoped do
      Participation.unscoped.joins(:shift).where("shifts.starts_at BETWEEN :from and :to", from: from_date, to: to_date).count
    end)
    volunteers_count_needed_percent = volunteers_needed > 0 ? 100 * volunteers_count.to_f / volunteers_needed : 0

    hours_needed = Shift.unscoped.where("starts_at BETWEEN :from and :to", from: from_date, to: to_date).sum("volunteers_needed * EXTRACT(EPOCH FROM (ends_at - starts_at)) / 3600").to_f
    hours_invested = (Participation.unscoped do
      Shift.unscoped.where("starts_at BETWEEN :from and :to", from: from_date, to: to_date).joins(:participations).sum("EXTRACT(EPOCH FROM (ends_at - starts_at))").to_f / 3600
    end)
    hours_invested_needed_percent = hours_needed > 0 ? 100 * hours_invested.to_f / hours_needed : 0

    render json: {
      update_fields: {
        user_count: User.unscoped.where("created_at BETWEEN :from and :to", from: from_date, to: to_date).count,
        ngo_count: Ngo.unscoped.where("created_at BETWEEN :from and :to", from: from_date, to: to_date).count,

        shift_count: Shift.unscoped.where("starts_at BETWEEN :from and :to", from: from_date, to: to_date).count,
        shift_distinct_event_count: Shift.unscoped.where("starts_at BETWEEN :from and :to", from: from_date, to: to_date).count("DISTINCT event_id"),

        volunteers_needed: volunteers_needed,
        volunteers_count: volunteers_count,
        volunteers_count_needed_percent: ("(" + ActionController::Base.helpers.number_to_percentage(volunteers_count_needed_percent, precision: 0) + ")"),

        hours_needed: hours_needed,
        hours_invested: hours_invested,
        hours_invested_needed_percent: ("(" + ActionController::Base.helpers.number_to_percentage(hours_invested_needed_percent, precision: 0) + ")"),

        report_created_at: l(Time.zone.now, format: :short)
      }
    }
  end

  content title: "Übersicht" do
    tabs do
      tab 'Statistik gesamt bisher' do
        attributes_table_for "" do
          row "Registrierungen" do
            div "#{User.unscoped.count} Freiwillige"
            div "#{Ngo.unscoped.count} NGOs"
          end
          row "Schichtbeginne" do
            div "#{Shift.unscoped.count} Schichten"
            div "in #{Shift.unscoped.count("DISTINCT event_id")} konkreten Einsätzen"
          end
          row "Anmeldungen für Schichten" do
            volunteers_needed = Shift.unscoped.sum(:volunteers_needed)
            volunteers_count = Participation.unscoped.where("shift_id IS NOT NULL").count
            count_needed_percent = volunteers_needed > 0 ? 100 * volunteers_count.to_f / volunteers_needed : 0

            div "#{volunteers_needed} Freiwillige für Schichten gesucht"
            div "#{volunteers_count} Anmeldungen erhalten (#{number_to_percentage(count_needed_percent, precision: 0)})"
          end
          row "Anmeldungen pro Freiwilliger (für Schichten)" do
            user_count = User.unscoped.count
            user_participation_counts = Participation.unscoped
                                       .where("shift_id IS NOT NULL")
                                       .group("user_id")
                                       .count
                                       .map { |_user_id, count| count }

            # add a 0-value for each user who has never participated
            user_participation_counts += Array.new(user_count - user_participation_counts.size, 0)

            if user_participation_counts.any?
              bin_boundaries = [0, 1, 2, 5, 10, 20]
              (bins, freqs) = user_participation_counts.histogram(bin_boundaries, :bin_boundary => :min)
              bins.each_with_index do |bin, i|
                bin_percent = user_count > 0 ? 100 * freqs[i].to_f / user_count : 0
                max = i+1 < bins.size ? bins[i+1].ceil : nil
                current_boundary = bin_boundaries[i]
                div safe_join([
                  "#{bin.ceil}#{i+1 == bins.size || bin_boundaries[i+1]-current_boundary > 1 ? "+": ""} Anmeldung#{current_boundary != 1 ? "en" : ""}:",
                  "#{freqs[i].to_i} Freiwillige",
                  "(#{number_to_percentage(bin_percent, precision: 0)})",
                  link_to("Liste", admin_users_path(scope: "by_participation_count", min: bin.ceil, max: max, participation_type: "shift"))
                ], " ")
              end
            end
            nil # return value displayed in row
          end
          row "Stunden für Schichten" do
            hours_needed = Shift.unscoped.sum("volunteers_needed * EXTRACT(EPOCH FROM (ends_at - starts_at)) / 3600").to_f
            hours_invested = (Participation.unscoped do
              Shift.unscoped.joins(:participations).sum("EXTRACT(EPOCH FROM (ends_at - starts_at))").to_f / 3600
            end)
            invested_needed_percent = hours_needed > 0 ? 100 * hours_invested.to_f / hours_needed : 0
            div "#{number_with_precision(hours_needed, precision: 0)} Stunden für Schichten gesucht"
            div "#{number_with_precision(hours_invested, precision: 0)} Stunden geleistet (#{number_to_percentage(invested_needed_percent, precision: 0)})"
          end

          row "Stunden pro Freiwilliger (für Schichten)" do
            user_count = User.unscoped.count
            user_hours_invested = (Participation.unscoped do
              Shift.unscoped
                   .joins(:participations)
                   .group(:user_id)
                   .sum("EXTRACT(EPOCH FROM(ends_at - starts_at))")
                   .map { |_user_id, hours| hours.to_f / 3600 }
            end)

            # add a 0-value for each user who has never participated
            user_hours_invested += Array.new(user_count - user_hours_invested.size, 0)

            if user_hours_invested.any?
              bin_boundaries = [0, 2, 4, 8, 16, 32]
              (bins, freqs) = user_hours_invested.histogram(bin_boundaries, :bin_boundary => :min)
              bins.each_with_index do |bin, i|
                bin_percent = user_count > 0 ? 100 * freqs[i].to_f / user_count : 0
                max = i+1 < bins.size ? bins[i+1] : nil
                div safe_join([
                  "#{number_to_human(bin, precision: 2, significant: false)}+ Stunden:",
                  "#{freqs[i].to_i} Freiwillige",
                  "(#{number_to_percentage(bin_percent, precision: 0)})",
                  link_to("Liste", admin_users_path(scope: "by_invested_hours", min: bin, max: max))
                ], " ")
              end
            end
            nil # return value displayed in row
          end
          row "Schichten pro NGO" do
            ngo_count = Ngo.unscoped.count
            ngo_shift_counts = (
              Event.unscoped do
                Shift.unscoped
                      .joins(:event)
                      .group("ngo_id")
                      .count
                      .map { |_ngo_id, count| count }
              end
            )

            # add a 0-value for each NGO who has not created a single shift
            ngo_shift_counts += Array.new(ngo_count - ngo_shift_counts.size, 0)

            if ngo_shift_counts.any?
              bin_boundaries = [0, 1, 2, 5, 10, 20]
              (bins, freqs) = ngo_shift_counts.histogram(bin_boundaries, :bin_boundary => :min)
              bins.each_with_index do |bin, i|
                bin_percent = ngo_count > 0 ? 100 * freqs[i].to_f / ngo_count : 0
                max = i+1 < bins.size ? bins[i+1].ceil : nil
                current_boundary = bin_boundaries[i]
                div safe_join([
                  "#{bin.ceil}#{i+1 == bins.size || bin_boundaries[i+1]-current_boundary > 1 ? "+": ""} Schicht#{current_boundary != 1 ? "en" : ""} erstellt:",
                  "#{freqs[i].to_i} NGOs",
                  "(#{number_to_percentage(bin_percent, precision: 0)})",
                  link_to("Liste", admin_ngos_path(scope: "by_created_shifts", min: bin.ceil, max: max))
                ], " ")
              end
            end
            nil # return value displayed in row
          end
          row "Dauerhafte Einsätze" do
            div "#{OngoingEvent.unscoped.count} dauerhafte Einsätze"

            volunteers_needed = OngoingEvent.unscoped.sum(:volunteers_needed)
            volunteers_count = Participation.unscoped.where("ongoing_event_id IS NOT NULL").count
            count_needed_percent = volunteers_needed > 0 ? 100 * volunteers_count.to_f / volunteers_needed : 0
            distinct_volunteers_count = Participation.unscoped.where("ongoing_event_id IS NOT NULL").count("DISTINCT user_id")

            div "für #{volunteers_needed} gesuchte Freiwillige"
            div "#{volunteers_count} Anmeldungen erhalten (#{number_to_percentage(count_needed_percent, precision: 0)})"

            div "von #{distinct_volunteers_count} verschiedenen Freiwilligen"
          end
          row "Dauerhafte Einsätze pro Freiwilliger" do
            user_count = User.unscoped.count
            user_participation_counts = Participation.unscoped
                                       .where("ongoing_event_id IS NOT NULL")
                                       .group("user_id")
                                       .count
                                       .map { |_user_id, count| count }

            # add a 0-value for each user who has never participated
            user_participation_counts += Array.new(user_count - user_participation_counts.size, 0)

            if user_participation_counts.any?
              bin_boundaries = [0, 1, 2, 5, 10, 20]
              (bins, freqs) = user_participation_counts.histogram(bin_boundaries, :bin_boundary => :min)
              bins.each_with_index do |bin, i|
                bin_percent = user_count > 0 ? 100 * freqs[i].to_f / user_count : 0
                max = i+1 < bins.size ? bins[i+1].ceil : nil
                current_boundary = bin_boundaries[i]
                div safe_join([
                  "#{bin.ceil}#{i+1 == bins.size || bin_boundaries[i+1]-current_boundary > 1 ? "+": ""} Anmeldung#{current_boundary != 1 ? "en" : ""}:",
                  "#{freqs[i].to_i} Freiwillige",
                  "(#{number_to_percentage(bin_percent, precision: 0)})",
                  link_to("Liste", admin_users_path(scope: "by_participation_count", min: bin.ceil, max: max, participation_type: "ongoing_event"))
                ], " ")
              end
            end
            nil # return value displayed in row
          end
        end
        div style: "color: #b3bcc1;" do
          "Bericht erstellt am #{l(Time.zone.now, format: :short)}"
        end

      end

      tab 'In definiertem Zeitraum' do
        attributes_table_for "" do
          row "Zeitraum" do
            form class: "filter_form", id: "statistics-date-form", :"data-remote" => true, action: admin_dashboard_date_filtered_path, method: "post" do
              input type: "text", name: "from_date", class: "datepicker", style: "width: 100px;", value: "#{1.month.ago.at_beginning_of_month.strftime "%Y-%m-%d"}"
              span "bis"
              input type: "text", name: "to_date", class: "datepicker", style: "width: 100px;", value: "#{1.month.ago.at_end_of_month.strftime "%Y-%m-%d"}"
              input type: "submit", value: "Aktualisieren"
            end
          end
          row "Registrierungen im Zeitraum", class: "statistics-result-row", style: "display: none;" do
            div do
              span "", id: "statistics-field-user_count"
              span "Freiwillige"
            end
            div do
              span "", id: "statistics-field-ngo_count"
              span "NGOs"
            end
          end
          row "Schichtbeginne im Zeitraum", class: "statistics-result-row", style: "display: none;" do
            div do
              span "", id: "statistics-field-shift_count"
              span "Schichten"
            end
            div do
              span "in"
              span "", id: "statistics-field-shift_distinct_event_count"
              span "konkreten Einsätzen"
            end
          end
          row "Anmeldungen für Schichten mit Beginn im Zeitraum", class: "statistics-result-row", style: "display: none;" do
            div do
              span "", id: "statistics-field-volunteers_needed"
              span "Freiwillige für Schichten gesucht"
            end
            div do
              span "", id: "statistics-field-volunteers_count"
              span "Anmeldungen erhalten"
              span "", id: "statistics-field-volunteers_count_needed_percent"
            end
          end
          row "Stunden für Schichten mit Beginn im Zeitraum", class: "statistics-result-row", style: "display: none;" do
            div do
              span "", id: "statistics-field-hours_needed"
              span "Stunden für Schichten gesucht"
            end
            div do
              span "", id: "statistics-field-hours_invested"
              span "Stunden geleistet"
              span "", id: "statistics-field-hours_invested_needed_percent"
            end
          end
          div class: "statistics-result-row", style: "display: none;color: #b3bcc1;" do
            span "Bericht erstellt am"
            span "", id: "statistics-field-report_created_at"
          end
        end
      end
    end
  end
end
