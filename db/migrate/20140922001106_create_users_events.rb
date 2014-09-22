class CreateUsersEvents < ActiveRecord::Migration
  def change
    create_table :users_events do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.string :profile

      t.timestamps
    end
  end
end
