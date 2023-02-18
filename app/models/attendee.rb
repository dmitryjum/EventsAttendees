class Attendee < ApplicationRecord
  include Paginatable
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum rsvp_status: {
    no: 0,
    yes: 1
  }

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :event_id
  validates :email, uniqueness: { scope: :event_id }
  validates_format_of :email, with: /@/
  before_save :downcase_email
  belongs_to :event

  def downcase_email
    self.email = self.email.delete(' ').downcase
  end
end