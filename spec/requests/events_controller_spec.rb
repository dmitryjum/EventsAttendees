require 'rails_helper'

describe V1::EventsController do
  before do
    @event1 = FactoryBot.create :event,
      name: "Event one",
      start_time: Time.zone.parse("2022-03-12") + 3.days,
      end_time: Time.zone.parse("2022-03-12") + 10.days,
      description: FFaker::Lorem.paragraph,
      event_type: "in_person"
    @event2 = FactoryBot.create :event,
      name: "Event two",
      start_time: Time.zone.parse("2022-03-12") + 4.days,
      end_time: Time.zone.parse("2022-03-12") + 11.days,
      description: FFaker::Lorem.paragraph,
      event_type: "in_person"
    @event3 = FactoryBot.create :event,
      name: "Event three",
      start_time: Time.zone.parse("2022-03-12") + 5.days,
      end_time: Time.zone.parse("2022-03-12") + 12.days,
      description: FFaker::Lorem.paragraph,
      event_type: "in_person"
    host! 'api.example.com'
  end

  context "it gets a list of events" do
    it "requests all events by start time and receives paginated response", focus: true do
      get v1_events_path(event: {start_time: "2022-03-15"}, per_page: 2)
      expect(json_response["entries_count"]).to be 1
      expect(json_response["records"].first["name"]).to eq "Event one"
    end

    it "requests all events by end time and receives paginated response", focus: true do
      get v1_events_path(event: {end_time: "2022-03-24"}, per_page: 2)
      expect(json_response["entries_count"]).to be 1
      expect(json_response["records"].first["name"]).to eq "Event three"
    end

    it "requests all events by start time and end time and receives paginated response", focus: true do
      get v1_events_path(event: {start_time: "2022-03-16", end_time: "2022-03-24"}, per_page: 2)
      expect(json_response["entries_count"]).to be 2
      expect(json_response["records"].map{|s| s["name"]}).to eq [@event2.name, @event3.name]
    end

    it "receives response as the object with 'records', 'entries_count', 'pages_per_limit', 'page' keys" do
      get v1_events_path
      expect(response.status).to be 200
      expect(json_response.keys).to eq ["records", "entries_count", "pages_per_limit", "page"]
    end

    it "returns all events" do
      get v1_events_path
      expect(json_response["records"].length).to eq 3
    end

    it "returns all events per requested page" do
      get v1_events_path(per_page: 2, page: 2)
      expect(json_response["records"].length).to eq 1
      expect(json_response["records"].first["name"]).to eq @event3.name
    end

    it "requests 2nd page and forgets to specify the limit and receives 2nd or last page with default of max 9 records per page" do
      get v1_events_path(page: 2)
      expect(json_response["records"].length).to be 3
      expect(json_response["records"].map{|s| s["name"]}).to eq [@event1.name, @event2.name, @event3.name]
    end

  end

  context "it gets an event by id" do
    it "finds an event by id" do
      get v1_event_path(id: @event1.id)
      expect(json_response['id']).to eq @event1.id
    end

    it "doesn't find an event by id" do
      get v1_event_path(id: 999)
      expect(response).not_to be_successful
      expect(json_response["error"]).to eq "Couldn't find Event with 'id'=999"
    end
  end

  context "it creates a new event" do
    it "succeeds creating a new event" do
      post v1_events_path(event: {name: "New Modern Event", description: "modern special secret event", event_type: "in_person"})
      expect(response.status).to be 201
      expect(Event.count).to be 4
      expect(json_response["description"]).to eq(Event.find_by_name("New Modern Event").description)
    end

    it "fails name validation" do
      post v1_events_path(event: {name: @event3.name, description: "event with duplicate name", event_type: "in_person"})
      expect(response.status).to be 422
      expect(json_response["name"].first).to eq "has already been taken"
    end
  end

  context "it updates an event" do
    it "successfuly updates an event" do
      patch v1_event_path(id: @event1.id, event: {name: "Event Ninety Nine"})
      expect(response.status).to be 200
      expect(json_response["name"]).to eq(Event.find(@event1.id).name)
    end

    it "fails to update an event" do
      patch v1_event_path(id: @event2.id, event: {name: @event1.name})
      expect(response.status).to be 422
      expect(json_response["name"].first).to eq "has already been taken"
    end
  end

  context "it destroys an event" do
    it "successfuly deletes an event" do
      delete v1_event_path(id: @event3.id)
      expect(response.status).to be 204
    end
  end

  context "it rspvs to an event" do
    it "successfuly creates an attendee record with rsvp true if didn't exist" do
      post rsvp_v1_event_path(id: @event3.id, attendee: {name: "John", email: "john@email.com"})
      expect(response.status).to be 200
      expect(json_response["name"]).to eq "John"
      expect(json_response["rsvp_status"]).to eq "yes"
    end

    it "successfuly creates an attendee record with rsvp true if it already exist" do
      attendee =  FactoryBot.create :attendee, event_id: @event1.id
      post rsvp_v1_event_path(id: @event1.id, attendee: {name: attendee.name, email: attendee.email})
      expect(response.status).to be 200
      expect(json_response["name"]).to eq attendee.name
      expect(json_response["rsvp_status"]).to eq "yes"
    end
  end
end