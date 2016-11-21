ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ I18n.t(".active_admin.dashboard")}, url: "/admin", html_options: { "data-turbolinks": "false" }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    #div class: "blank_slate_container", id: "dashboard_default_message" do
      #span class: "blank_slate" do
        #span I18n.t("active_admin.dashboard_welcome.welcome")
        #small I18n.t("active_admin.dashboard_welcome.call_to_action")
      #end
    #end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end
    columns do
      column do
        panel "Volunteer Statistics" do
          h4 "Event Count"
          h2 do
            strong StatisticOperation::EventCount::Show.new.({})
          end

          h4 "Total of participating volunteers for all shifts/events"
          h2 do
            strong StatisticOperation::TotalParticipants::Show.new.({})
          end

          h4 "Sum of required volunteers for all shifts/events"
          h2 do
            strong StatisticOperation::RequiredVolunteers::Show.new.({})
          end

          h4 "Sum of volunteer work hours that have been organized through Where2Help"
          h2 do
            strong StatisticOperation::VolunteerWorkHours::Show.new.({})
          end
        end
      end
    end
    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
