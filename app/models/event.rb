# frozen_string_literal: true

class Event < ApplicationRecord
  include Paginatable
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum event_type: {
    virtual: 0,
    in_person: 1
  }

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :attendees, dependent: :destroy

  def self.where_params_are(params)
    params = params.stringify_keys
    time_params = {}
    other_params = {}
    params.each do |k, v|
      if %w[start_time end_time].include?(k)
        time_params[k] = Time.zone.parse(v)
      else
        other_params[k] = v
      end
    end

    events = where(other_params)
    if time_params["start_time"].present? && time_params["end_time"].present?
      # looks up the events by the range between start time and end time given
      events.where("start_time >= ? AND end_time <= ?", time_params["start_time"], time_params["end_time"])
    elsif time_params["start_time"].present? || time_params["end_time"].present?
      events.where(time_params)
    else
      events
    end
  end
end
