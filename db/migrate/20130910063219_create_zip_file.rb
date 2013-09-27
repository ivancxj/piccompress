class CreateZipFile < ActiveRecord::Migration
  def change
    create_table :zip_files do |t|
      t.string  :name
      t.string  :file
      t.string  :download
      t.timestamps
    end
  end
end
