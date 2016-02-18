class CreateLanguagesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :languages_users do |t|

      t.timestamps
    end
  end
end
