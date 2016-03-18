class DandelionreportsController < ApplicationController
# access at /dandelionreports
  # the data should be sent as part of the request body.
  def create
    @dandelionreports = DandelionReport.new(params[:dandelionreport])
    reportData = @dandelionreports.split('\n') 
    reportData.each do |d|
      ent = d.split(',')
	    r = Report.create({ :moisture1 => ent[0], :moisture1 => ent[1],  })
      r.moisture1 = ent[0]
      r.moisture2 = ent[1]
      r.moisture3 = ent[2]
      r.humidity = ent[3]
      r.temperature = ent[4]
	    r.batterylevel = ent[5]
      r.reporttime = ent[6]
	    r.dandelionid = ent[7]
	    r.stateid = ent[8]
    end
    # issue a standard HTTP Status Code 202 (accepted) reponse to the request
    render :accepted
  end
end
