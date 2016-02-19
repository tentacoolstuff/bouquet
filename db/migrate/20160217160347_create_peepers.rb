class CreatePeepers < ActiveRecord::Migration
  def change
    create_table :peepers do |t|

      t.timestamps
    end
  end
end
