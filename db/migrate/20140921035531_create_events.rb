class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :eventName
      t.string :password
      t.integer :admin_id
      t.integer :participants
      t.integer :spendingLimit
      t.text :match, :array => true
      t.date :expire

      t.timestamps
    end
  end
end
