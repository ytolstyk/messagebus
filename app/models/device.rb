# == Schema Information
#
# Table name: devices
#
#  id         :integer          not null, primary key
#  date       :date
#  time       :time
#  male       :boolean
#  device     :string(255)
#  activity   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Device < ActiveRecord::Base
end
