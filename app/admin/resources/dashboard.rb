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
end
