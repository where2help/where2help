# frozen_string_literal: true

module DeviseHelper
  def module_for(resource)
    ActiveModel::Naming.plural(resource)
  end
end
