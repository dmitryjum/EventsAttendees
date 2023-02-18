require 'rails_helper'

describe V1::EventsController do
  before do
    @event1 = FactoryBot.create :event,
      name: "Event one",
      start_time: Time.zone.now + 3.days,
      end_time: Time.zone.now + 10.days,
      description: FFaker::Lorem.paragraph,
      event_type: "in_person"
    @event2 = FactoryBot.create :event,
      name: "Event two",
      start_time: Time.zone.now + 4.days,
      end_time: Time.zone.now + 11.days,
      description: FFaker::Lorem.paragraph,
      event_type: "in_person"
    @event3 = FactoryBot.create :event,
      name: "Event three",
      start_time: Time.zone.now + 5.days,
      end_time: Time.zone.now + 12.days,
      description: FFaker::Lorem.paragraph,
      event_type: "in_person"
    host! 'api.example.com'
  end

  context 'request an event by id' do
    it 'finds an event by id' do
      get v1_event_path(id: @event1.id)
      expect(json_response["id"]).to eq @event1.id
    end
  end
end