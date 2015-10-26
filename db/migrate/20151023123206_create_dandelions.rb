class CreateDandelions < ActiveRecord::Migration
  def change
    create_table :dandelions do |t|

      t.timestamps
    end
  end
end
