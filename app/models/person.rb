# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  starting_weight :decimal(, )
#  up_by           :decimal(, )
#  league_id       :integer
#

class Person < ActiveRecord::Base

  has_many :checkins
  has_many :user_person_joins
  has_many :users, through: :user_person_joins
  belongs_to :league

  scope :by_general_delta_position, -> (event) {
    select("people.*, max(checkins.id), max(checkins.created_at), max(checkins.general_delta)").
        joins(:checkins => :event).
        joins("INNER JOIN (
                SELECT person_id, event_id, max(c.id) id, max(c.created_at) created_at FROM checkins c group by person_id, event_id
              ) as max_checkins
              ON max_checkins.person_id = checkins.person_id
                and max_checkins.event_id = checkins.event_id
                and max_checkins.id = checkins.id").
        where(checkins: {event: event}).
        order('max(checkins.general_delta) IS NULL, max(checkins.general_delta) desc').
        group('people.id, people.name')
  }

  scope :leaderboard_for, ->(event) {
    by_general_delta_position(event).limit(10)
  }

  scope :league_leaderboard_for, ->(event, league){
    by_general_delta_position(event).where(league: league).limit(10)
  }

  def up_by(event=nil)
    return attributes['up_by'] unless event
    checkins_from_event = event.checkins.where(person: self).order(:created_at)
    first_checkin = checkins_from_event.first
    last_checkin = checkins_from_event.last
    last_checkin == first_checkin ? nil : last_checkin.weight - first_checkin.weight
  end

  def percentage_change
    return unless up_by
    @percentage_change ||= starting_weight ?  up_by.to_f / starting_weight * 100 : nil
  end

  def percentage_change_by_event(event)
    event_checkins = checkins.includes(:event).where(event: event).order('checkins.created_at')
    first_checkin = event_checkins.first
    last_checkin = event_checkins.last
    return nil if first_checkin.nil? || last_checkin.nil? || last_checkin.general_delta.nil?
    last_checkin.general_delta / first_checkin.weight * 100
  end

  def checkin_diffs
    grouped = checkins.includes(:event).order('events.created_at').group_by(&:event)
    event_diffs = {}
    grouped.each_pair do |event, event_checkins|
      diffs = event_checkins.sort_by(&:created_at).map(&:delta).compact
      event_diffs[event.try(:name)] = diffs.map { |d| '%.2f' % d }
    end
    event_diffs
  end
end
