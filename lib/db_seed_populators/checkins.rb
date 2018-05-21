module DbSeedPopulators
  class Checkins < DbSeedPopulator
    def initialize(rows)
      @rows = rows
    end

    def record_block
      @record_block ||= ->(row){
        Checkin.new(person: available_people[row['Name']], event: available_events[row['Event']], weight: row['Weight'], created_at: row['Time'])
      }
    end

    private

    def available_people
      @people_hash ||= Hash[*Person.all.map do |person|
        [person.name, person]
      end.flatten]
    end

    def available_events
      @events_hash ||= Hash[*Event.all.map do |event|
        [event.name, event]
      end.flatten]
    end
  end
end