# frozen_string_literal: true

class Attendee < ApplicationRecord
  include Paginatable
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum rsvp_status: {
    no: 0,
    yes: 1
  }

  validates :name, presence: true
  validates :email, presence: true
  validates :event_id, presence: true
  validates :email, uniqueness: { scope: :event_id }
  validates :email, format: { with: /@/ }
  before_save :downcase_email
  belongs_to :event

  def downcase_email
    self.email = email.delete(" ").downcase
  end
end
