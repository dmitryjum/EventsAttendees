class V1::EventsController < ApplicationController
  before_action :get_event, only: [:update, :destroy, :rsvp]

  def index
    props = params[:event].present? ? event_params : {}
    events = Event.where_params_are(props).paginate(params)
    render json: events, status: :ok
  end

  def show
    event = Rails.cache.fetch("event_#{params[:id]}", expires: 30.minutes) do
      Event.includes(:attendees).friendly.find(params[:id])
    end
    attendees = event.attendees.paginate(params)
    event_json = event.as_json
    event_json["attendees"] = attendees.as_json
    render json: event_json, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: {error: e.to_s }, status: :not_found
  end

  def create
    event = Event.new(event_params)
    if event.save
      render status: :created, json: event
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render status: :ok, json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  def rsvp
    attendee = @event.attendees.find_by_email(attendee_params[:email])
    if attendee.nil?
      attendee = @event.attendees.new(attendee_params.merge(rsvp_status: "yes"))
    else
      attendee.attributes = {name: attendee_params[:name], rsvp_status: "yes"}
    end

    if attendee.save
      render status: :ok, json: attendee
    else
      render json: attendee.errors, status: :unprocessable_entity
    end
  end

  private

  def get_event
    @event = Event.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {error: e.to_s }, status: :not_found
  end

  def event_params
    params.require(:event).permit(:name, :start_time, :end_time, :description, :type)
  end

  def attendee_params
    params.require(:attendee).permit(:name, :email, :event_id)
  end

end