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
    fem_half = devices.where(male: false).count / 2
    mal_half = devices.where(male: true).count / 2

    data = {}

    data[:numbers] = [
      (devices.take(half).map!{|el| el.activity}.inject(&:+).to_f / devices.take(half).count.to_f * 100).round(1),
      (devices.drop(half).map!{|el| el.activity}.inject(&:+).to_f / devices.drop(half).count.to_f * 100).round(1)
    ]

    data[:female] = [
      (devices.where(male: false).take(fem_half).map!{|el| el.activity}.inject(&:+).to_f / devices.where(male: false).take(fem_half).count.to_f * 100).round(1),
      (devices.where(male: false).drop(fem_half).map!{|el| el.activity}.inject(&:+).to_f / devices.where(male: false).drop(fem_half).count.to_f * 100).round(1)
    ]

    data[:male] = [
      (devices.where(male: true).take(mal_half).map!{|el| el.activity}.inject(&:+).to_f / devices.where(male: true).take(mal_half).count.to_f * 100).round(1),
      (devices.where(male: true).drop(mal_half).map!{|el| el.activity}.inject(&:+).to_f / devices.where(male: true).drop(mal_half).count.to_f * 100).round(1)
    ]

    data[:device_data] = [
      {
          value: devices.where(device: :mobile).count,
          color:"#F7464A",
          highlight: "#FF5A5E",
          label: "Mobile"
      },
      {
          value: devices.where(device: :tablet).count,
          color: "#46BFBD",
          highlight: "#5AD3D1",
          label: "Tablet"
      },
      {
          value: devices.where(device: :desktop).count,
          color: "#FDB45C",
          highlight: "#FFC870",
          label: "Desktop"
      }
    ]    

    render json: return_json(days_array, data, segments([TODAY]))
  end

  def three_days
    days_array = days(2)

    render json: return_json(days_array, populate_data(days_array), segments(days_array))
  end

  def seven_days
    days_array = days(6)

    render json: return_json(days_array, populate_data(days_array), segments(days_array))
  end

  def fourteen_days
    days_array = days(13)

    render json: return_json(days_array, populate_data(days_array), segments(days_array))
  end

  def segments(days_array)
    devices = Device.where(date: days_array)
    seg = {}

    seg[:male] = devices.where(male: true).count
    seg[:female] = devices.where(male: false).count
    seg[:all] = devices.count

    seg
  end

  def populate_data(days_array)
    devices = Device.where(date: days_array)

    data = Hash.new { |h, k| h[k] = [] }

    days_array.each do |day|
      data[:numbers] << (devices.where(date: day).pluck(:activity).inject(&:+).to_f / devices.where(date: day).count.to_f * 100).round(1)
      data[:male] << (devices.where(date: day).where(male: true).pluck(:activity).inject(&:+).to_f / devices.where(date: day).where(male: true).count.to_f * 100).round(1)
      data[:female] << (devices.where(date: day).where(male: false).pluck(:activity).inject(&:+).to_f / devices.where(date: day).where(male: false).count.to_f * 100).round(1)
    end

    data[:device_data] = [
      {
          value: devices.where(device: :mobile).count,
          color:"#F7464A",
          highlight: "#FF5A5E",
          label: "Mobile"
      },
      {
          value: devices.where(device: :tablet).count,
          color: "#46BFBD",
          highlight: "#5AD3D1",
          label: "Tablet"
      },
      {
          value: devices.where(device: :desktop).count,
          color: "#FDB45C",
          highlight: "#FFC870",
          label: "Desktop"
      }
    ]

    data
  end

  def days(num)
    days_array = [TODAY]

    num.times do |i|
      days_array << TODAY - (i + 1).day
    end
    
    days_array.reverse
  end

  def return_json(labels, data, segments)
    len = data[:numbers].length
    avg = (data[:numbers].inject(&:+).to_f / len).round(1)

    first = data[:numbers].first
    last = data[:numbers].last
    step = ((last - first).to_f / (len - 1).to_f)

    trend = []
    len.times do |i|
      trend << (first + i * step).round(1)
    end

    data = { labels: labels,
             datasets: [
              {
                fillColor: "rgba(151,187,205,0.5)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: "#fff",
                data: data[:numbers]
              }
             ],
            segments: segments,
            female_data: {
              fillColor: "rgba(220,220,220,0.5)",
              strokeColor: "rgba(220,220,220,1)",
              pointColor: "rgba(220,220,220,1)",
              pointStrokeColor: "#fff",
              data: data[:female]
              },
            male_data: {
              fillColor: "rgba(220,220,220,0.5)",
              strokeColor: "rgba(220,220,220,1)",
              pointColor: "rgba(220,220,220,1)",
              pointStrokeColor: "#fff",
              data: data[:male]
              },
            device_data: data[:device_data],
            mean_data: {
              fillColor: "rgba(220,220,220,0.5)",
              strokeColor: "rgba(220,220,220,1)",
              pointColor: "rgba(220,220,220,1)",
              pointStrokeColor: "#fff",
              data: [avg] * data[:numbers].length
              },
            trend_data: {
              fillColor: "rgba(220,220,220,0.5)",
              strokeColor: "rgba(220,220,220,1)",
              pointColor: "rgba(220,220,220,1)",
              pointStrokeColor: "#fff",
              data: trend
              }
      }
  end
end
