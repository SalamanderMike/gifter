class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :eventName
      t.string :password
      t.integer :admin_id
      t.string :participants
      t.integer :spendingLimit
      t.string :match
      t.date :expire

      t.timestamps
    end
  end
end
