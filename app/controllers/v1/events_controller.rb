class V1::EventsController < ApplicationController
  before_action :get_event, only: [:show, :update, :destroy, :rsvp]

  def index
    events = Event.where_params_are(params).paginate(params)
    render json: events, status: 200
  end

  def show
    render json: event, status: 200
  rescue ActiveRecord::RecordNotFound => e
    render json: {error: e.to_s }, status: :not_found
  end

  def create
    event = Event.new(event_params)
    if event.save
      render status: 201, json: event
    else
      render json: event.errors, status: :unprocessible_entity
    end
  end

  def update
    if @event.udpate(event_params)
      render status: 200, json: event
    else
      render json: event.errors, status: :unprocessible_entity
    end
  end

  def destroy
    if event.nil?
      render json: { message: "Event not found" }, status: :not_found
    else
      if event.destroy
        render json: { message: "Event deleted" }
      else
        render json: { message: "Event could not be deleted" }, status: :unprocessible_entity
    end
  end

  def rsvp
  end

  private

  def get_event
    event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :start_time, :end_time, :description, :type)
  end

end