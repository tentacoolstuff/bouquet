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
    @moistureStatus = Array.new(@dandelions.length)
    @humidityStatus = Array.new(@dandelions.length)
    @irrigationStatus = Array.new(@dandelions.length)
    @secondReport = Array.new(@dandelions.length)
    @wateringTime = Array.new(@dandelions.length)
    @m0 = Array.new(@dandelions.length)
    @m1 = Array.new(@dandelions.length)
    @mt = Array.new(@dandelions.length)

    $j = 0
    while $j < @dandelions.length do
      @allReports[$j] = Report.where(dandelionid: @dandelions[$j].id).last
      @lastReport = Report.where(dandelionid: @dandelions[$j].id).last(2)
      @secondReport[$j] = @lastReport[0]
      @allReports[$j].moisture1 = '%.2f' % @allReports[$j].moisture1
      #moisture
      @moistureDifference = (@allReports[$j].moisture1 + @allReports[$j].moisture2 + @allReports[$j].moisture3)/3 - @dandelions[$j].moistureLimit
      if @moistureDifference > 0.2
        @moistureStatus[$j] = 'well above the threshold'
        @irrigationStatus[$j] = 'No action needed'
      elsif @moistureDifference <= 0.2 and @moistureDifference > 0
        @moistureStatus[$j] = 'close to limit'
        @irrigationStatus[$j] = 'Irrigation soon'
      elsif @moistureDifference <= 0 and 
        @moistureStatus[$j] = 'below limit'
        @irrigationStatus[$j] = 'Irrigate needed'
      end

      #humidity
      if @allReports[$j].humidity > 0.75
        @humidityStatus[$j] = 'very high.'
      elsif @allReports[$j].humidity <= 0.75  and @allReports[$j].humidity > 0.5
        @humidityStatus[$j] = 'high.'
      elsif @allReports[$j].humidity <= 0.5  and @allReports[$j].humidity > 0.25
        @humidityStatus[$j] = 'moderate.'
      elsif @allReports[$j].humidity <= 0.25
        @humidityStatus[$j] = 'low.'
      end

      #wateringSchedule
      @mt[$j] = @dandelions[$j].moistureLimit
      @m0[$j] = (@allReports[$j].moisture1 + @allReports[$j].moisture2 + @allReports[$j].moisture3)/3
      @m1[$j] = (@secondReport[$j].moisture1 + @secondReport[$j].moisture1 + @secondReport[$j].moisture1)/3
      @deltaT = 10;
      @wateringTime[$j] = ((@m0[$j]-@mt[$j])*(@deltaT))/(@m1[$j]-@m0[$j])
      if @wateringTime[$j] < 0 and @moistureDifference < 0
        @wateringTime[$j] = "is required immediately."
      elsif @wateringTime[$j] < 0 and @moistureDifference >=0
        @wateringTime[$j] = "occurred recently, new schedule is being calculated."
      else
        @temp =  '%.0f' % @wateringTime[$j]
        @wateringTime[$j] = 'should occur in approximately ' + @temp + ' minutes.'
      end
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
  end
  
  def openValve
    @id = params[:valveID]
    @result = system("python sunflower-interface.py --open " + @id)
    render :text => "success"
  end

  def closeValve
    @id = params[:valveID]
    @result = system("python sunflower-interface.py --close "+ @id)

    render :text => "success"
    puts "success"+@id
  end
  
  private
  def dandelion_params
    ##params.require(:article).permit(:name, :uuid, etc)
  end
end
