class Attendee < ApplicationRecord
  validates_presence_of :name
  validates_presense_of :email
  validates_format_of :email, with: /@/
  before_save :downcase_email
end