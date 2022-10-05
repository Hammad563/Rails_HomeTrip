class Reservation < ApplicationRecord
  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  has_one :calender_event, dependent: :destroy, required: true

  enum status: {pending: 0, booked: 1, cancelling: 2, cancelled: 3, expired: 4 }
  delegate :start_date, to: :calender_event
  delegate :end_date, to: :calender_event
  delegate :nights, to: :calender_event


end
