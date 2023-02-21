# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do
  describe "#where_params_are" do
    let!(:event1) do
      create(:event,
             name: "Event 1",
             start_time: Time.zone.parse("2023-02-20 10:00:00"),
             end_time: Time.zone.parse("2023-02-20 11:00:00"),
             event_type: :in_person,
             description: FFaker::Lorem.paragraph)
    end
    let!(:event2) do
      create(:event,
             name: "Event 2",
             start_time: Time.zone.parse("2023-02-20 12:00:00"),
             end_time: Time.zone.parse("2023-02-20 13:00:00"),
             event_type: :virtual,
             description: FFaker::Lorem.paragraph)
    end
    let!(:event3) do
      create(:event,
             name: "Event 3",
             start_time: Time.zone.parse("2023-02-20 14:00:00"),
             end_time: Time.zone.parse("2023-02-20 15:00:00"),
             event_type: :in_person,
             description: FFaker::Lorem.paragraph)
    end

    context "when only other params are provided" do
      it "returns events that match the other params" do
        events = described_class.where_params_are({ event_type: :in_person })
        expect(events).to match_array([event1, event3])
      end
    end

    context "when start_time and end_time are provided" do
      it "returns events that fall within the time range" do
        events = described_class.where_params_are({ event_type: :in_person, start_time: "2023-02-20 9:30:00",
                                                    end_time: "2023-02-20 15:30:00" })
        expect(events).to match_array([event1, event3])
      end
    end
  end
end
