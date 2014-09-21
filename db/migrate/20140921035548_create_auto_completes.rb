class CreateAutoCompletes < ActiveRecord::Migration
  def change
    create_table :auto_completes do |t|
      t.string :cuisine
      t.string :shops
      t.string :services
      t.string :booksGenre
      t.string :musicGenre
      t.string :toys
      t.string :hobbies
      t.string :clothes
      t.string :art
      t.string :color
      t.string :animals
      t.string :metal
      t.string :element

      t.timestamps
    end
  end
end
