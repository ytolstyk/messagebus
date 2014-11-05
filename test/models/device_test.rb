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

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
