class Reservation < ApplicationRecord
  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  
  enum status: {pending: 0, booked: 1, cancelling: 2, cancelled: 3, }

end
