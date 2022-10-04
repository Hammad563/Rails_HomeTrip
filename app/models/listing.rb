class Listing < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :rooms
  has_many :photos
  has_many :reservations

  validates :title, presence: true
  enum status: [:draft, :published, :archived]
  validates :max_guests, numericality: {greater_than: 0, less_than: 100 }
  validates :nighty_price, numericality: {greater_than: 0 }
  validates :cleaning_fee, numericality: {greater_than: 0 }

  scope :with_published, -> { where(status: :published)}

  after_commit :create_stripe_product, on: [:create, :update]


  def create_stripe_product
    return if !stripe_product_id.blank?
    product = Stripe::Product.create(
      name: title,
      url: Rails.application.routes.url_helpers.url_for(self),
      metadata: {
        homeTrip_id: id,
      }
    )
    self.update(stripe_product_id: product.id)
  end

end
