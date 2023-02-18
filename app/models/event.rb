class Event < ApplicationRecord
  include Paginatable

  enum event_type: {
    virtual: 0,
    in_person: 1
  }

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :attendees, dependent: :destroy

  def self.where_params_are params
    # think about params conditions to filter events by start and end date
    all
  end
end