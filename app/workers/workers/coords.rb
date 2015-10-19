require 'jobs/coords'

class Workers::Coords
  include SuckerPunch::Job

  def perform(need_id)
    need = Need.find(need_id)
    Jobs::Coords.add_to(need)
  end
end
