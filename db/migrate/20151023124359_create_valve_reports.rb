class CreateValveReports < ActiveRecord::Migration
  def change
    create_table :valve_reports do |t|

      t.timestamps
    end
  end
end
