module DbSeedPopulators
  class People < DbSeedPopulator
    def initialize(rows)
      @rows = rows
      @people_added = []
    end

    def record_block
      ->(row) {
        return nil if already_added?(row['Name'])
        person = Person.new(name: row['Name'], league: available_leagues[row['League']])
        @people_added << person.name
        person
      }
    end

    def prepare
      pre_populate_associations
    end

    private
    def pre_populate_associations
      leagues = @rows.map do |row| row['League'] end.uniq.map do |league_name| League.new(name: league_name) end
      League.import(leagues.uniq)
      events = @rows.map do |row| {name: row['Event'], date: row['Date']} end.uniq.map do |event| Event.new(name: event[:name], created_at: event[:date]) end
      Event.import(events.uniq)
    end

    def available_leagues
      @leagues_hash ||= Hash[*League.all.map do |league|
        [league.name, league]
      end.flatten]
    end

    def available_people
      @people_hash ||= Hash[*Person.all.map do |person|
        [person.name, person]
      end.flatten]
    end

    def already_added?(name)
      @people_added.include?(name)
    end
  end
end