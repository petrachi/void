class CreateProvinces < ActiveRecord::Migration[5.1]
  def change
    create_table :provinces do |t|
      t.references :planet
      t.string :blob

      t.timestamps
    end
  end
end
