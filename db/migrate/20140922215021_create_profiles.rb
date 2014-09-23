class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.integer :zip
      t.text :cuisine, :array => true
      t.text :shops, :array => true
      t.text :services, :array => true
      t.text :bookGenre, :array => true
      t.text :musicGenre, :array => true
      t.text :clothes, :array => true
      t.text :color, :array => true
      t.text :animal, :array => true
      t.text :metal, :array => true
      t.text :element, :array => true
      t.text :art, :array => true
      t.text :hobbies, :array => true

      t.timestamps
    end
  end
end
