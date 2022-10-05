class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def create
    puts "#{reservation_params}"
    @reservation = current_user.reservations.new(reservation_params)
    if @reservation.save!
      # create stripe checkout session
      @listing = @reservation.listing
      checkout_session = Stripe::Checkout::Session.create(
        success_url: reservation_url(@reservation),
        cancel_url: listing_url(@listing),
        customer: current_user.stripe_customer,
        mode: 'payment',
        line_items: [{
          price_data: {
            unit_amount: @listing.nighty_price,
            currency: 'cad',
            product: @listing.stripe_product_id,

          },
          quantity: 1 #num of nights
        }, {
          price_data: {
            unit_amount: @listing.cleaning_fee,
            currency: 'cad',
            product: 'prod_MY6f6j7DAn6FCA' # cleaning fee product ID
          },
          quantity: 1
        }],
        metadata: {
          reservation_id: @reservation.id
        },
        payment_intent_data: {
          application_fee_amount: ((@listing.cleaning_fee + @listing.nighty_price) * 0.1).to_i,
          transfer_data: {
            destination: @listing.host.stripe_account_id
          },
          metadata: {
            reservation_id: @reservation.id
          }
        }
      )
      @reservation.update(session_id: checkout_session.id )
      redirect_to checkout_session.url
    else
      # error
      flash[:errors] = @reservation.errors.full_messages
      redirect_to listing_path(params[:reservation][:listing_id])
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


  private

  def reservation_params
    params.require(:reservation).permit(:listing_id)
  end

end
