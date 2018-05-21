# == Schema Information
#
# Table name: leagues
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class League < ActiveRecord::Base
  has_many :people, dependent: :nullify
end
