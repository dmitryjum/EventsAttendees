# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.text :description
      t.integer :event_type

      t.timestamps
    end
  end
end
