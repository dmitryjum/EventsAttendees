class V1::AttendeesController < ApplicationController
  before_action :get_attendee, only: [:show, :update, :destroy]

  def show
    render json: @attendee, status: :ok
  end

  #creation of an attendee can serve the purpose of an invitation with rsvp_status false
  #hence "répondez s'il vous plaît" - "please reply"
  def create
    event = Event.find(params[:event_id])
    attendee = event.attendees.new(attendee_params)
    if attendee.save
      render status: :created, json: attendee
    else
      render json: attendee.errors, status: :unprocessable_entity
    end
  end

  def update
    if @attendee.update(attendee_params)
      render status: :ok, json: @attendee
    else
      render json: @attendee.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @attendee.destroy
    head :no_content
  end

  private

  def get_attendee
    @attendee = Attendee.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {error: e.to_s }, status: :not_found
  end

  def attendee_params
    params.require(:attendee).permit(:name, :email, :event_id)
  end
end