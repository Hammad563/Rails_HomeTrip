# To deliver this notification:
#
# GuestBookedNotification.with(post: @post).deliver_later(current_user)
# GuestBookedNotification.with(post: @post).deliver(current_user)

class GuestBookedNotification < Noticed::Base
  # Add your delivery methods
  #
   deliver_by :database
   deliver_by :email, mailer: "ReservationMailer", method: :guest_booked
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
   param :reservation

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
