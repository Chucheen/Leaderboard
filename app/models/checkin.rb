# == Schema Information
#
# Table name: checkins
#
#  id         :integer          not null, primary key
#  weight     :decimal(, )      default(0.0)
#  person_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  event_id   :integer
#  delta      :decimal(, )
#  user_id    :integer
#

class Checkin < ActiveRecord::Base
  belongs_to :person
  belongs_to :event
  belongs_to :user
end
