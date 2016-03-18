class DandelionsController < ApplicationController
  layout "application"
#list all dandelion data
  def index
    @dandelions = Dandelion.all
    @reports = Array.new(@dandelions.length)
    $i = 0

    while $i < @dandelions.length do
     @reports[$i] = Report.where(dandelionid: @dandelions[$i].id).last
       @reports[$i].moisture1 = '%.2f' % @reports[$i].moisture1
       @reports[$i].moisture2 = '%.2f' % @reports[$i].moisture2
       @reports[$i].moisture3 = '%.2f' % @reports[$i].moisture3
       @reports[$i].humidity  = '%.3f' % @reports[$i].humidity
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
    @allReports = Array.new(@dandelions.length)
    $j = 0
    while $j < @dandelions.length do
      @allReports[$j] = Report.where(dandelionid: @dandelions[$j].id).last
      @allReports[$j].moisture1 = '%.2f' % @allReports[$j].moisture1

      $j +=1
    end

    if params[:id] == 'irrigation'
       render :action =>'irrigation'

    else
      @dandelion = Dandelion.find(params[:id])
      @reports = Report.where(dandelionid: params[:id]).last(72)
      @lastReport = Report.where(dandelionid: params[:id]).last

      

      respond_to do |format|
        format.html { render layout: "individual" }
        format.json { render json: @reports }
      end
    
    end
  end

  def irrigation
    #@dandelions = Dandelion.all
    @reports = Array.new(@dandelions.length)
    $j = 0
    while $j < @dandelions.length do
     @reports[$j] = Report.where(dandelionid: @dandelions[$j].id).last
       $j += 1
    end
    @allReports = Array.new(@dandelions.length)
    $i = 0
    while $i < @dandelions.length do
     @allReports[$i] = Report.where(dandelionid: @dandelions[$i].id).last
       $i +=1
    end
  end
  
  def openValve
    @result = system("python sunflower-interface.py --open 0")
    render :text => "success"
  end

  def closeValve
    @result = system("python sunflower-interface.py --close 0")
    render :text => "success"
  end
  
  private
  def dandelion_params
    ##params.require(:article).permit(:name, :uuid, etc)
  end
end
