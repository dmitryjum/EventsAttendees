class Event < ApplicationRecord
  include Paginatable
  validates_presense_of :name
  validates_uniqueness_of :name

  has_many :attendees, dependent: :destroy

  def self.where_params_are params
    # think about params conditions
    all
  end
end