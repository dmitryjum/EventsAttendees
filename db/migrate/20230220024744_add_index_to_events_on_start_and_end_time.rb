class AddIndexToEventsOnStartAndEndTime < ActiveRecord::Migration[7.0]
  def change
    add_index :events, [:start_time, :end_time]
  end
end
