class V1::EventsController < ApplicationController
  before_action :get_event, only: [:show, :update, :destroy, :rsvp]

  def index
    events = Event.where_params_are(params).paginate(params)
    render json: events, status: :ok
  end

  def show
    render json: @event, status: :ok
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
    attendee = @event.attendees.new(params[:booking_params])
    if attendee.save
      render status: :created, json: attendee
    else
      render json: attendee.errors, status: :unprocessable_entity
    end
  end

  private

  def get_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {error: e.to_s }, status: :not_found
  end

  def event_params
    params.require(:event).permit(:name, :start_time, :end_time, :description, :type)
  end

end