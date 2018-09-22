# frozen_string_literal: true

require "delegate"
class NgoDecorator < SimpleDelegator
  def status
    _status = "pending"
    if deleted_at.present?
      _status = "deleted"
    elsif admin_confirmed_at.present?
      # we only care about if the admin confirmed the NGO at this point
      _status = "confirmed"
    end
    Ngo.human_attribute_name("state-#{_status}")
  end
end
