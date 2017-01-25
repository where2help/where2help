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
          row "Stunden für Schichten" do
            hours_needed = Shift.unscoped.sum("volunteers_needed * (ends_at - starts_at)").to_f
            hours_invested = (Participation.unscoped do
              Shift.unscoped.joins(:participations).sum("(ends_at - starts_at)").to_f
            end)
            invested_needed_percent = hours_needed > 0 ? 100 * hours_invested.to_f / hours_needed : 0
            div "#{number_with_precision(hours_needed, precision: 0)} Stunden für Schichten gesucht"
            div "#{number_with_precision(hours_invested, precision: 0)} Stunden geleistet (#{number_to_percentage(invested_needed_percent, precision: 0)})"
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
        end
        # TODO histograms
      end

      tab 'In definiertem Zeitraum' do
        # TODO specific date range statistics
      end
    end
  end
end
