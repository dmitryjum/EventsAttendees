class Attendee < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :email
  validates_format_of :email, with: /@/
  before_save :downcase_email
  belongs_to :event

  def downcase_email
    self.email = self.email.delete(' ').downcase
  end
end