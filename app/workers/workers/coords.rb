require 'jobs/coords'

module Workers
  class Coords
    include SuckerPunch::Job

    def perform(need_id)
      need = Need.find(need_id)
      Jobs::Coords.add_to(need)
    end
  end
end
