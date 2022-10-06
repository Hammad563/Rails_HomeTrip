class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = current_user.reservations
    @host_reservations = current_user.host_reservations
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def new
    @listing = Listing.find(params[:listing_id])
    @calender_events = @listing.calender_events
  end

  def create
    @booking = BookListing.new(current_user, reservation_params)
    if @booking.save
      redirect_to @booking.checkout_url, allow_other_hosts: :true, status: :see_other
    else
      flash.now[:errors] = @booking.errors
      @listing = @booking.listing
      @reservation = @booking.reservation
      @calender_events = @listing.calender_events
      render :new
    end
  end

  def cancel
    @reservation = current_user.reservations.find(params[:id])
    # refund payment
    refund = Stripe::Refund.create({
      payment_intent: @reservation.payment_intent_id
    })
    @reservation.update(stripe_refund_id: refund.id, status: :cancelling)
    redirect_to reservation_path(@reservation)
  end

  def expire
    @reservation = current_user.reservations.find(params[:id])

    if @reservation.status != 'expired'
      Stripe::Checkout::Session.expire(params[:session_id])
    end
    
    redirect_to listings_path
  end


  private

  def reservation_params
    params.require(:reservation).permit(:listing_id, :start_date, :end_date)
  end

end
