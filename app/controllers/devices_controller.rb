class DevicesController < ApplicationController
  TODAY = "2014-07-31".to_date

  def index
    @devices = Device.all
    render json: @devices
  end

  def today
    # Y axis = $ of total_rows/activity_recorded
    # X axis = auto-adjusts based on date and segment selection
    
    devices = Device.where(date: TODAY).order(:time)
    half = devices.count / 2

    labels = [devices.first.date, devices[half].date, devices.last.date]

    data = []
    render json: return_json(labels, data)
  end

  def three_days
    days_array = days(2)

    render json: return_json(days_array, populate_data(days_array))
  end

  def seven_days
    days_array = days(6)

    render json: return_json(days_array, populate_data(days_array))
  end

  def fourteen_days
    days_array = days(13)

    render json: return_json(days_array, populate_data(days_array))
  end

  def populate_data(days_array)
    devices = Device.where(date: days_array)

    data = []
    days_array.each do |day|
      data << devices.where(date: day).pluck(:activity).inject(&:+)
    end
    data
  end

  def days(num)
    days_array = [TODAY]
    num.times do |i|
      days_array << TODAY - (i + 1).day
    end
    days_array.reverse
  end

  def return_json(labels, data)
    data = { labels: labels,
             datasets: [
              {
                fillColor: "rgba(151,187,205,0.5)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: "#fff",
                data: data
              }
             ]
      }
  end
end
