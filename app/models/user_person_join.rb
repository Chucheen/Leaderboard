# == Schema Information
#
# Table name: user_person_joins
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  times_used :integer          default(1)
#

class UserPersonJoin < ActiveRecord::Base
  belongs_to :user
  belongs_to :person
end
