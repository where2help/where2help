module DeviseHelper
  def module_for(resource)
    ActiveModel::Naming.plural(resource)
  end
end
