class CreateCheckin

  def self.call(person, event, weight, current_user)
    return if ENV['QUIET_MODE']
    first_checkin = Checkin.where(person: person, event: event).order(created_at: :asc).first
    previous_checkin = Checkin.where(person: person, event: event).order(created_at: :desc).first
    if previous_checkin
      delta = weight - previous_checkin.weight
      general_delta = weight - first_checkin.weight
    end

    Checkin.create(person: person, event: event, weight: weight, delta: delta, general_delta: general_delta, user: current_user)
    if person.starting_weight
      person.up_by = weight - person.starting_weight
    else
      person.starting_weight = weight
    end
    person.save

    if current_user && !current_user.people.include?(person)
      current_user.user_person_joins.create(person: person)
    elsif current_user && current_user.people.include?(person)
      join = current_user.user_person_joins.find_by(person: person)
      join.times_used += 1
      join.save
    end
  end
end