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

  context "it gets a list of events" do
  end

  context "it gets an event by id" do
    it 'finds an event by id' do
      get v1_event_path(id: @event1.id)
      expect(json_response["id"]).to eq @event1.id
    end

    it "doesn't find an event by id" do
      get v1_event_path(id: 999)
      expect(response).not_to be_successful
      expect(json_response["error"]).to eq "Couldn't find Event with 'id'=999"
    end
  end

  context 'it creates a new event' do
    it 'succeeds creating a new event' do
      post v1_events_path(event: {name: "New Modern Event", description: "modern special secret event", event_type: "in_person"})
      expect(response.status).to be 201
      expect(Event.count).to be 4
      expect(json_response["description"]).to eq(Event.find_by_name("New Modern Event").description)
    end

    it 'fails name validation' do
      post v1_events_path(event: {name: @event3.name, description: "event with duplicate name", event_type: "in_person"})
      expect(response.status).to be 422
      expect(json_response["name"].first).to eq "has already been taken"
    end
  end

  context 'it updates an event' do
    it 'successfuly updates an event' do
      patch v1_event_path(id: @event1.id, event: {name: "Event Ninety Nine"})
      expect(response.status).to be 200
      expect(json_response["name"]).to eq(Event.find(@event1.id).name)
    end

    it 'fails to update an event' do
      patch v1_event_path(id: @event2.id, event: {name: @event1.name})
      expect(response.status).to be 422
      expect(json_response["name"].first).to eq "has already been taken"
    end
  end

  context 'it destroys an event' do
    it 'successfuly deletes an event' do
      delete v1_event_path(id: @event3.id)
      expect(response.status).to be 204
    end
  end

  context 'it rspvs to an event' do
  end
end