ActiveAdmin.register_page "Statistic" do
  menu priority: 8, label: "Statistik"

  content title: "Statistik" do
    tabs do
      tab 'Gesamt bisher' do
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
              (bins, freqs) = user_participation_counts.histogram(:bin_boundary => :min)
              bins.each_with_index do |bin, i|
                bin_percent = user_count > 0 ? 100 * freqs[i].to_f / user_count : 0
                max = i+1 < bins.size ? bins[i+1].ceil : nil
                div safe_join([
                  "#{bin.ceil}+ Anmeldungen:",
                  "#{freqs[i].to_i} Freiwillige",
                  "(#{number_to_percentage(bin_percent, precision: 0)})",
                  link_to("Liste", admin_users_path(scope: "by_participation_count", min: bin.ceil, max: max, participation_type: "shift"))
                ], " ")
              end
            end
            nil # return value displayed in row
          end
          row "Stunden für Schichten" do
            hours_needed = Shift.unscoped.sum("volunteers_needed * (ends_at - starts_at)").to_f
            hours_invested = (Participation.unscoped do
              Shift.unscoped.joins(:participations).sum("(ends_at - starts_at)").to_f
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
                   .sum("(ends_at - starts_at)")
                   .map { |_user_id, hours| hours.to_f }
            end)

            # add a 0-value for each user who has never participated
            user_hours_invested += Array.new(user_count - user_hours_invested.size, 0)

            if user_hours_invested.any?
              (bins, freqs) = user_hours_invested.histogram(:bin_boundary => :min)
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
            ngo_shift_counts = Shift.unscoped
                                    .joins(:event)
                                    .group("ngo_id")
                                    .count
                                    .map { |_ngo_id, count| count }

            # add a 0-value for each NGO who has not created a single shift
            ngo_shift_counts += Array.new(ngo_count - ngo_shift_counts.size, 0)

            if ngo_shift_counts.any?
              (bins, freqs) = ngo_shift_counts.histogram(:bin_boundary => :min)
              bins.each_with_index do |bin, i|
                bin_percent = ngo_count > 0 ? 100 * freqs[i].to_f / ngo_count : 0
                div "#{bin.ceil}+ Schichten erstellt: #{freqs[i].to_i} NGOs (#{number_to_percentage(bin_percent, precision: 0)})"
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
              (bins, freqs) = user_participation_counts.histogram(:bin_boundary => :min)
              bins.each_with_index do |bin, i|
                bin_percent = user_count > 0 ? 100 * freqs[i].to_f / user_count : 0
                max = i+1 < bins.size ? bins[i+1].ceil : nil
                div safe_join([
                  "#{bin.ceil}+ Anmeldungen:",
                  "#{freqs[i].to_i} Freiwillige",
                  "(#{number_to_percentage(bin_percent, precision: 0)})",
                  link_to("Liste", admin_users_path(scope: "by_participation_count", min: bin.ceil, max: max, participation_type: "ongoing_event"))
                ], " ")
              end
            end
            nil # return value displayed in row
          end
        end
      end

      tab 'In definiertem Zeitraum' do
        # TODO specific date range statistics
      end
    end
  end
end
