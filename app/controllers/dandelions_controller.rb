class DandelionsController < ApplicationController
  def show
	@dandelion = Dandelion.find('983d3578-3178-42fb-964f-fd57af189242')
	@reports = Report.where(dandelionid: '983d3578-3178-42fb-964f-fd57af189242').last(10)
  end
  
  private
  def dandelion_params
    ##params.require(:article).permit(:name, :uuid, etc)
  end
end
