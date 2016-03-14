class SunflowersController < ApplicationController
  def index
  	@sunflowers = Sunflower.all
  end

  def show
    @sunflower = Sunflower.find('24f7b3b3-4782-4f40-b849-2262fc56608d')
	@dandelions = Dandelion.where(sunflowerID: '24f7b3b3-4782-4f40-b849-2262fc56608d')
	$i = 0
	@reports = Array.new(@dandelions.length)
    while $i < @dandelions.length  do
       @reports[$i] = Report.where(dandelionid: @dandelions[$i].id).last
       $i +=1
    end
end
end