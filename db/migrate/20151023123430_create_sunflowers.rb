class CreateSunflowers < ActiveRecord::Migration
  def change
    create_table :sunflowers do |t|

      t.timestamps
    end
  end
end
