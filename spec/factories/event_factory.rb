# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { FFaker::Name.name }
  end
end
