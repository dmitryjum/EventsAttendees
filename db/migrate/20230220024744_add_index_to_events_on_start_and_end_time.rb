# frozen_string_literal: true

class AddIndexToEventsOnStartAndEndTime < ActiveRecord::Migration[7.0]
  def change
    add_index :events, %i[start_time end_time]
  end
end
