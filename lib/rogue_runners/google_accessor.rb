# frozen_string_literal: true

require 'google_drive'
require 'set'

module RogueRunners
  module GoogleWorksheets
    class Accessor
      ROGUE_WORKBOOK = 'Strava Rogue Miles'
      COLUMN_NAMES = %w[Name Sex Date Miles ActivityID].freeze
      ACTIVITY_ID_COL = 5

      def initialize(client_secret)
        @session = GoogleDrive::Session.from_config(client_secret)
        @workbook = @session.spreadsheet_by_name(ROGUE_WORKBOOK)
        @worksheet = get_current_sheet || add_new_worksheet
        @ids = get_activity_ids
      end

      def worksheet_name
        @sheet_name ||= "#{Date.today.strftime('%B')} #{Date.today.year}"
      end

      def get_current_sheet
        @workbook.worksheet_by_title(worksheet_name)
      end

      def add_new_worksheet
        ws = @spreadsheet.add_worksheet(worksheet_name)
        COLUMN_NAMES.each_with_index do |colname, ix|
          ws[1, ix + 1] = colname
        end
        ws.save
        ws
      end

      def get_activity_ids
        @row = 2
        activity_ids = Set.new
        until @worksheet[@row, 1].empty?
          activity_ids << @worksheet[@row, ACTIVITY_ID_COL].to_s
          @row += 1
        end
        activity_ids
      end

      def add_new_activities(run_summary_list)
        runs_to_be_added = run_summary_list.reject { |run| @ids.include?(run.last.to_s) }
        puts "#{runs_to_be_added.count} runs to add, starting with row #{@row}"
        runs_to_be_added.each do |run|
          run.each_with_index do |value, ix|
            col = ix + 1
            @worksheet[@row, col] = value.to_s
          end
          @row += 1
        end
        @worksheet.save
      end
    end
  end
end
