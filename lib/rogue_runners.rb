require "rogue_runners/version"
require 'rogue_runners/strava_accessor'
require 'rogue_runners/google_accessor'

module RogueRunners

  class RunCollector

    def initialize(strava_token, google_client_secret)
      @strava_accessor = Strava::Accessor.new(strava_token)
      @google_accessor = GoogleWorksheets::Accessor.new(google_client_secret)
    end

    def update_miles
      run_summary_list = @strava_accessor.current_month_runs_summary
      @google_accessor.add_new_activities(run_summary_list)
    end

  end

end
