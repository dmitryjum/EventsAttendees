require 'rails_helper'

describe V1::AttendeesController do
  let!(:event1) { FactoryBot.create :event,
    name: "Event one",
    start_time: Time.zone.parse("2022-03-12") + 3.days,
    end_time: Time.zone.parse("2022-03-12") + 10.days,
    description: FFaker::Lorem.paragraph,
    event_type: "in_person" }
  let!(:attendee1) { FactoryBot.create :attendee, name: "John Doe", rsvp_status: "yes", event_id: event1.id }

  context "it gets an attendee by id" do
    it "finds an attendee by id" do
      get v1_attendee_path(id: attendee1.id)
      expect(json_response['id']).to eq attendee1.id
    end

    it "finds an attendee by friendly id" do
      get v1_attendee_path(id: "john-doe")
      expect(json_response['id']).to eq attendee1.id
    end

    it "doesn't find an event by id" do
      get v1_attendee_path(id: 999)
      expect(response).not_to be_successful
      expect(json_response["error"]).to eq "Couldn't find Attendee with 'id'=999"
    end
  end

  context "it creates a new attendee (invitation record that needs to be rsvped if accepted)" do
    it "successfuly creates a new attendee" do
      test_attendee = {name: FFaker::Name.name, email: FFaker::Internet.email}
      post v1_attendees_path(event_id: event1.id, attendee: test_attendee)
      expect(response.status).to be 201
      expect(Attendee.count).to be 2
      expect(json_response["email"]).to eq(test_attendee[:email])
    end

    it "fails email validation" do
      test_attendee = {name: FFaker::Name.name}
      post v1_attendees_path(event_id: event1.id, attendee: test_attendee)
      expect(response.status).to be 422
      expect(json_response["email"].first).to eq "can't be blank"
    end
  end

  context "it updates an attendee" do
    it "successfuly updates an attendee" do
      patch v1_attendee_path(id: attendee1.id, attendee: {rsvp_status: "no"})
      expect(response.status).to be 200
      expect(json_response["rsvp_status"]).to eq(Attendee.find(attendee1.id).rsvp_status)
    end

    it "fails to update an attendee" do
      attendee2 = FactoryBot.create :attendee, event_id: event1.id
      patch v1_attendee_path(id: attendee2.id, attendee: {email: attendee1.email})
      expect(response.status).to be 422
      expect(json_response["email"].first).to eq "has already been taken"
    end
  end

  context "it destroys an attendee" do
    it "successfuly deletes an attendee" do
      delete v1_attendee_path(id: attendee1.id)
      expect(response.status).to be 204
    end
  end
end