class CalenderEvent < ApplicationRecord
  belongs_to :listing
  belongs_to :reservation

  validates :status, presence: true
  enum status: { reserved: 0, blocked: 1 }

  
  validates :start_date, presence: true
  validates :end_date, presence: true

  # start date cannot fall after end date
  validates :start_date, comparison: { less_than: :end_date }

  # start date must be greater than today and less than 1 year from today
  validates :start_date, inclusion: { in: (Date.today..Date.today + 365)  }

  #dates dont overlap with other timeslots for this listing
  validates :start_date, :end_date, overlap: {
    exclude_edges: ['start_date', 'end_date'],
    scope: :listing_id,
    query_options: {
      joins: 'LEFT OUTER JOIN reservations r on r.id = calender_events.reservation_id',
      where: 'r.status in (0,1) or calender_events.status = 1'
    },
    message_content: "Place is already booked for this date range"
  }


  def nights
    (start_date...end_date).count
  end

end
