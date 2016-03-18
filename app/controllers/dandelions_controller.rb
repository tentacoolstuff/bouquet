class DandelionsController < ApplicationController
  layout "application"
#list all dandelion data
  def index
    @dandelions = Dandelion.all
    @reports = Array.new(@dandelions.length)
    $i = 0

    while $i < @dandelions.length do
     @reports[$i] = Report.where(dandelionid: @dandelions[$i].id).last
       @reports[$i].moisture1 = '%.1f' % @reports[$i].moisture1
       @reports[$i].moisture2 = '%.1f' % @reports[$i].moisture2
       @reports[$i].moisture3 = '%.1f' % @reports[$i].moisture3
       $i +=1
    end

    respond_to do |format|
      format.html 
      format.json { render json: @dandelions }
    end
  end

#show individual dandelion data 
  def show
    @dandelions = Dandelion.all
	 #@dandelion = Dandelion.find('983d3578-3178-42fb-964f-fd57af189242')
    @dandelion = Dandelion.find(params[:id])
	  @reports = Report.where(dandelionid: params[:id]).last(72)
    @lastReport = Report.where(dandelionid: params[:id]).last
    
    respond_to do |format|
      format.html { render layout: "individual" }
      format.json { render json: @reports }
    end
  end
  
  private
  def dandelion_params
    ##params.require(:article).permit(:name, :uuid, etc)
  end
end
