class BookListing
    include Rails.application.routes.url_helpers
    attr_reader :current_user, :params

    def initialize(current_user, params)
        @current_user = current_user
        @params = params
    end


    def listing
        @listing ||= Listing.find(listing_id)
    end

    def calender_event
        @calender_event ||= CalenderEvent.new(start_date: start_date, end_date: end_date, listing: listing, status: :reserved, reservation: reservation)
    end

    def reservation
        @reservation ||= Reservation.new(listing: listing, guest: current_user)
    end

    def valid? 
        calender_event.valid? || reservation.valid?
    end
    def errors
        calender_event.errors.full_messages + reservation.errors.full_messages
    end

    def save
        if valid?
            calender_event.save && reservation.save
        end
    end

    def checkout_url
        checkout_session.url
    end

    def checkout_session
            return @checkout_session if @checkout_session
            # create stripe checkout session
            @checkout_session = Stripe::Checkout::Session.create(
                success_url: reservation_url(reservation),
                cancel_url: expire_reservation_url(reservation) + "?session_id={CHECKOUT_SESSION_ID}",
                customer: current_user.stripe_customer,
                mode: 'payment',
                allow_promotion_codes: true,
                submit_type: 'book',
                expires_at: 1.hour.from_now.to_i,
                line_items: [{
                price_data: {
                    unit_amount: listing.nighty_price,
                    currency: 'cad',
                    product: listing.stripe_product_id,

                },
                quantity: reservation.nights #num of nights
                }, {
                price_data: {
                    unit_amount: listing.cleaning_fee,
                    currency: 'cad',
                    product: 'prod_MY6f6j7DAn6FCA' # cleaning fee product ID
                },
                quantity: 1
                }],
                metadata: {
                    listing_id: listing.id,
                    reservation_id: reservation.id,
                    guest_id: current_user.id,
                    start_date: start_date,
                    end_date: end_date
                },
                payment_intent_data: {
                    application_fee_amount: ((listing.cleaning_fee + listing.nighty_price) * 0.1).to_i,
                    transfer_data: {
                        destination: listing.host.stripe_account_id
                    },
                    metadata: {
                        reservation_id: reservation.id,
                        listing_id: listing.id,
                        guest_id: current_user.id,
                        start_date: start_date,
                        end_date: end_date
                    }
                }
            )
            reservation.update(session_id: @checkout_session.id )
            checkout_session
            #redirect_to @checkout_session.url  
    end




    private

    def listing_id
        params[:listing_id]
    end

    def start_date
        params[:start_date]
    end

    def end_date
        params[:end_date]
    end


end