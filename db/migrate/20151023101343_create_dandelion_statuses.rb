class CreateDandelionStatuses < ActiveRecord::Migration
  def change
    create_table :dandelion_statuses do |t|

      t.timestamps
    end
  end
end
