# frozen_string_literal: true

FactoryBot.define do
  factory :attendee do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
  end
end
