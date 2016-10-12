class AddPersonToEvent < ActiveRecord::Migration[5.0]
  def up
    add_column :events, :person, :string
    Event.all.each do |event|
      event.update(person: "unbekannt")
    end
  end

  def down
    remove_column :events, :person
  end
end
