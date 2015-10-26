class Valves < ActiveRecord::Base
  belongs_to :sunflower
  has_many :valve_reports
end
