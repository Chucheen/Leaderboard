# == Schema Information
#
# Table name: user_location_joins
#
#  id          :integer          not null, primary key
#  location_id :integer          not null
#  user_id     :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class UserLocationJoin < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
end
