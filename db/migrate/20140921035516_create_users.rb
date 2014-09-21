class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.string :username
      t.string :password
      t.integer :zip
      t.string :match
      t.string :purchase
      t.string :personality

      t.timestamps
    end
  end
end
