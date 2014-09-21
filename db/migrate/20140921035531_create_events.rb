class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :eventName
      t.string :groupID
      t.string :participants
      t.integer :spendingLimit
      t.date :expire

      t.timestamps
    end
  end
end
