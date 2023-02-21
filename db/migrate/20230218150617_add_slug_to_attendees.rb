# frozen_string_literal: true

class AddSlugToAttendees < ActiveRecord::Migration[7.0]
  def change
    add_column :attendees, :slug, :string
    add_index :attendees, :slug, unique: true
  end
end
