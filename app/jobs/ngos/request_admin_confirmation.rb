module Ngos
  class RequestAdminConfirmation
    include SuckerPunch::Job

    def perform(user)
      AdminMailer.ngo_confirmation_request(user).deliver
    end
  end
end
