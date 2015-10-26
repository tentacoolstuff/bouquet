class CreateValveStatuses < ActiveRecord::Migration
  def change
    create_table :valve_statuses do |t|

      t.timestamps
    end
  end
end
