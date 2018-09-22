# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin
class AdminPreview < ActionMailer::Preview
  def new_ngo
    AdminMailer.new_ngo(Ngo.first)
  end
end
