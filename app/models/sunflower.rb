class Sunflower < ActiveRecord::Base
  has_many :valves
  has_many :dandelions
  #has_many :reports through :dandelions
  #has_many :valve_reports through :valves
end
