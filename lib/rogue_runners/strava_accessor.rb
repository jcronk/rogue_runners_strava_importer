# frozen_string_literal: true

require 'strava/api/v3'

module RogueRunners
  module Strava
    class Accessor
      CLUB_ID = 328_489
      METERS_PER_MILE = 1609.34
      RUN_FILTER = proc do |activity|
        activity['type'] == 'Run'
      end
      CURRENT_MONTH_FILTER = proc do |row|
        row[2].month == Date.today.month
      end

      def initialize(token)
        access_token = File.exist?(token) ? File.open(token).read.chomp : token
        @client = ::Strava::Api::V3::Client.new(access_token: access_token)
        @all_activities = []
      end

      def transform_athlete(athlete)
        first_last = athlete.values_at('firstname', 'lastname').map(&:to_s)
        return athlete['username'] if first_last.join('').empty?
        [first_last.join(' '), athlete['sex']]
      end

      def transform_activity(activity)
        [
          transform_athlete(activity['athlete']),
          ActivityDate.new(activity['start_date']),
          distance_to_miles(activity['distance']),
          activity['id']
        ].flatten
      end

      def distance_to_miles(distance)
        format('%0.2f', (distance / METERS_PER_MILE))
      end

      def get_activity_list
        page = 1
        until (list = @client.list_club_activities(CLUB_ID, page: page)).empty?
          page += 1
          @all_activities.concat(list)
        end
        @all_activities
      end

      def get_runs
        @runs = @all_activities.select(&RUN_FILTER)
      end

      def transform_runs
        @runs_summary = @runs.map(&method(:transform_activity))
      end

      def current_month_runs_summary
        get_activity_list
        get_runs
        transform_runs
        @runs_summary.select(&CURRENT_MONTH_FILTER)
      end
    end

    class ActivityDate
      def initialize(date)
        @date = Date.parse(date)
      end

      def to_s
        @date.strftime('%Y-%m-%d')
      end

      def method_missing(method_name, *args)
        @date.send(method_name, *args)
      end
    end
  end
end
