class EventsController < ApplicationController
  def index
    @events = Event.all.order(:id)
  end

  def show
    @event = Event.find(params[:id])
    @leaderboard = Person.leaderboard_for(@event)
    @league_leaderboards = []
    League.all.each do |league|
      records = Person.league_leaderboard_for(@event, league)
      @league_leaderboards << {league: league, leaderboard: records} unless records.empty?
    end
  end

  def create
    @event = Event.create(event_params)
    redirect_to people_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :tagline)
  end
end
