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
    days_array = [devices.first.time.to_s(:time), devices.last.time.to_s(:time)]
    half = devices.count / 2

    data = [
      devices.take(half).map!{|el| el.activity}.inject(&:+),
      devices.drop(half).map!{|el| el.activity}.inject(&:+)
    ]

    render json: return_json(days_array, data)
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
      data << (devices.where(date: day).pluck(:activity).inject(&:+).to_f / devices.where(date: day).count.to_f * 100).round(1)
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
             ],
            segments: {
              all: 1,
              male: 2,
              female: 3
            }
      }
  end
end
