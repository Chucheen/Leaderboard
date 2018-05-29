require 'spec_helper'

describe Person do
  let(:league) {League.create}
  let(:league2) {League.create}
  let(:person) { Person.create(league: league) }
  let(:person2) { Person.create(league: league) }
  let(:person3) { Person.create(league: league2) }
  let(:e1) { Event.create(name: '1', created_at: 1.year.ago)}
  let(:user) { User.create(email: 'tester@murphyweighin.com', password: 'eat2compete') }
  let(:p1c1) { CreateCheckin.call(person, e1, 100, user)}
  let(:p1c2) { CreateCheckin.call(person, e1, 200, user)}
  let(:p1c3) { CreateCheckin.call(person, e1, 250, user)}

  let(:p2c1) { CreateCheckin.call(person2, e1, 100, user)}
  let(:p2c2) { CreateCheckin.call(person2, e1, 300, user)}
  let(:p2c3) { CreateCheckin.call(person2, e1, 350, user)}

  let(:p3c1) { CreateCheckin.call(person3, e1, 80, user)}
  let(:p3c2) { CreateCheckin.call(person3, e1, 100, user)}
  let(:p3c3) { CreateCheckin.call(person3, e1, 120, user)}

  let(:e2) { Event.create(name: '2', created_at: 1.day.ago)}
  let(:p1c4) { CreateCheckin.call(person, e2, 101, user)}
  let(:p1c5) { CreateCheckin.call(person, e2, 202, user)}
  let(:p1c6) { CreateCheckin.call(person, e2, 303, user)}

  describe '#up_by' do
    subject { person.up_by }
    context 'with no event specified' do
      context 'with 0 checkins' do
        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
      context 'with one checkin' do
        before { p1c1 }
        it 'returns 0' do
          expect(subject).to be_nil
        end
      end
      context 'with two checkins' do
        before { p1c1; p1c2 }
        it 'calculates the difference between first and last Checkin' do
          expect(subject).to eql(100)
        end
      end
      context 'with many checkins' do
        before { p1c1; p1c2; p1c3}
        it 'calculates the difference between first and last Checkin' do
          expect(subject).to eql(150)
        end
      end
      context 'with many events' do
        before { p1c4; p1c5; p1c6 }
        it 'only uses the checkins from the last event' do
          expect(subject).to eql(202)
        end
      end
    end
    context 'with an event specified' do
      before { p1c4; p1c5; p1c6 }
      subject { person.up_by(e1) }

      context 'with 0 checkins' do
        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
      context 'with one checkin' do
        before { p1c1 }
        it 'returns 0' do
          expect(subject).to be_nil
        end
      end
      context 'with two checkins' do
        before { p1c1; p1c2 }
        it 'calculates the difference between first and last Checkin' do
          expect(subject).to eql(100)
        end
      end
      context 'with many checkins' do
        before { p1c1; p1c2; p1c3}
        it 'calculates the difference between first and last Checkin' do
          expect(subject).to eql(150)
        end
      end
    end
  end
  describe '#percentage_change' do
    subject { person.percentage_change }
    context 'with 0 checkins' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
    context 'with one checkin' do
      before { p1c1 }
      it 'returns 0' do
        expect(subject).to be_nil
      end
    end
    context 'with two checkins' do
      before { p1c1; p1c2 }
      it 'calculates the difference between first and last Checkin' do
        expect(subject.to_f).to eq(100.0)
      end
    end
    context 'with many checkins' do
      before { p1c1; p1c2; p1c3}
      it 'calculates the difference between first and last Checkin' do
        expect(subject.to_f).to eq(150.0)
      end
    end
    context 'with many events' do
      before { p1c4; p1c5; p1c6 }
      it 'only uses the checkins from the last event' do
        expect(subject.to_f).to eql(200.0)
      end
    end
  end
  describe '#checkin_diffs' do
    subject { person.checkin_diffs }
    context 'with one event' do
      before {p1c1; p1c2; p1c3}
      it 'gives the difference between checkins, in order' do
        expect(subject).to eql({"1" => ['100.00','50.00']})
      end
    end
    context 'with many events' do
      before { p1c4; p1c5; p1c6; p1c1; p1c2; p1c3; }
      it 'maps the events to the checkins' do
        expect(subject).to eql({"1" => ['100.00','50.00'], "2" => ['101.00', '101.00']})
      end
    end
  end
  describe '#leaderboarding general' do
    subject {
      Person.leaderboard_for(e1)
    }
    before { person; person2; person3; p1c1; p1c2; p1c3; p2c1; p2c2; p2c3; p3c1; p3c2; p3c3; }
    it 'shows the leaderboard in the right order' do
      expect(subject).to match_array([person2,person,person3])
    end
  end

  describe '#leaderboarding within a league' do
    subject { Person.league_leaderboard_for(e1, league)}
    before { person; person2; person3; p1c1; p1c2; p1c3; p2c1; p2c2; p2c3; p3c1; p3c2; p3c3; }
    it 'shows the league leaderboard in the right order' do
      expect(subject).to match_array([person2,person])
    end
    it "doesn't include someone outside the league" do
      expect(subject).not_to include([person3])
    end
  end
end
