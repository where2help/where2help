require "concepts/ngo/decorator"
context.instance_eval do
  selectable_column
  id_column
  column :name
  column :email
  column :locale
  column(:state) do |ngo|
    ngo = NgoDecorator.new(ngo)
    status_tag(ngo.status)
  end
  actions
end
