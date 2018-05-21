class CreatePlanets < ActiveRecord::Migration[5.1]
  def change
    create_table :planets do |t|

      t.timestamps
    end
  end
end
