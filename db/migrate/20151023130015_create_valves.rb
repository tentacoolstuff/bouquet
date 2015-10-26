class CreateValves < ActiveRecord::Migration
  def change
    create_table :valves do |t|

      t.timestamps
    end
  end
end
