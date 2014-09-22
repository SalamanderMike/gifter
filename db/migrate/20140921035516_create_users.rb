class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :password_digest
      t.integer :zip
      t.string :purchase
      t.string :personality

      t.timestamps
    end
  end
end
