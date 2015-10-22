class AddVolunteeringsCountToNeeds < ActiveRecord::Migration
  def up
    add_column :needs, :volunteerings_count, :integer, default: 0, null: false

    say_with_time 'Reset counter cache for existing need records' do
      Need.find_each do |n|
        Need.reset_counters(n.id, :volunteerings)
      end
    end
  end

  def down
    remove_column :needs, :volunteerings_count
  end
end
