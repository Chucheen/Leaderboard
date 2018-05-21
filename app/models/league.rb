# == Schema Information
#
# Table name: leagues
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  event_id_id :integer
#

class League < ActiveRecord::Base
  has_many :people, dependent: :nullify
end
