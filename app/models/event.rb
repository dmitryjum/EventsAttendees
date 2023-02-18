class Event < ApplicationRecord
  include Paginatable
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum event_type: {
    virtual: 0,
    in_person: 1
  }

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :attendees, dependent: :destroy

  def self.where_params_are params
    time_params = {}
    other_params = {}
    params.each do |k,v|
      if k == "start_time" || k == "end_time"
        time_params[k] = Time.zone.parse(v)
      else
        other_params[k] = v
      end
    end

    events = where(other_params)
    if time_params["start_time"].present? && time_params["end_time"].present?
      events.where("start_time >= ? AND end_time <= ?", time_params["start_time"], time_params["end_time"])
    else
      events.where(time_params)
    end
  end
end