module Ngos
  class RequestAdminConfirmation
    include SuckerPunch::Job

    def perform(user)
      AdminMailer.ngo_confirmation_request(user).deliver_now
    end
  end
end
