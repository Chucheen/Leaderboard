namespace :checkins do
  desc "Backfill deltas on weights"
  task backfill_deltas: :environment do
    Checkin.find_each do |c|
      checkins = Checkin.where(person: c.person, event: c.event).where('created_at < ?', c.created_at)
      if checkins.last
        delta = c.weight - checkins.last.weight
        c.delta = delta
        c.general_delta = c.weight - checkins.first.weight
        c.save
      end
    end
  end
end
