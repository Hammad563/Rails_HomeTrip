class EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    case event.source
    when "stripe"
      stripe_event = Stripe::Event.construct_from(JSON.parse(event.request_body, symbolize_names: true))
      
      begin
        stripe_handle(stripe_event)
        event.update(status: :processed, error_message: '', event_type: stripe_event.type)
      rescue => e
        event.update(error_message: e.message, status: :failed)
      end
    else
      event.update(error_message: "No source match #{event.source}")
    end
  end


  def stripe_handle(stripe_event)
    case stripe_event.type
    when "checkout.session.completed"
      # checkout
      checkout_session = stripe_event.data.object
      reservation = Reservation.find_by(session_id: checkout_session.id)

      if reservation.nil?
        raise "No reservation found, checkout_session_id: #{checkout_session.id}"
      end
      reservation.update(status: :booked, payment_intent_id: checkout_session.payment_intent )
      GuestBookedNotification.with(reservation: reservation).deliver_later(reservation.guest)
      HostBookedNotification.with(reservation: reservation).deliver_later(reservation.host)
    when "checkout.session.expired"
      checkout_session = stripe_event.data.object
      reservation = Reservation.find_by(session_id: checkout_session.id)
      if reservation.nil?
        raise "No reservation found, checkout_session_id: #{checkout_session.id}"
      end
      reservation.update(status: :expired)

    when "charge.refunded"
      #refund
      charge=  stripe_event.data.object
      reservation = Reservation.find_by(payment_intent_id: charge.payment_intent)

      if reservation.nil?
        raise "No reservation found, payment_intent: #{charge.payment_intent}"
      end
      reservation.update(status: :cancelled)
    when "account.updated"
      # stripe connect account
      account = stripe_event.data.object
      user = User.find_by(stripe_account_id: account.id)
      if account.charges_enabled
        user.update(charges_enabled: true)
      end
    end
  end
end
