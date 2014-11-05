# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

keys = []

File.readlines("sample_data.csv").each_with_index do |line, i|
  line_split = line.chomp.split(",")

  if i == 0
    keys = line_split.map do |key|
      key.downcase!
    end

    next
  end

  entry = {}

  line_split.each_with_index do |el, i|
    if i == 2
      if el == "male"
        entry[keys[i]] = true
      else
        entry[keys[i]] = false
      end
    elsif i == 0
      el = el.split("/")
      entry[keys[i]] = "#{el.last}-#{el.first}-#{el[1]}"
    else
      entry[keys[i]] = el
    end
  end

  Device.create!(entry)
end