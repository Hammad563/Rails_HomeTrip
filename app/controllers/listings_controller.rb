class ListingsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @listings = pagy(Listing.with_published, items: 10)
  end

  def show
    @listing = Listing.with_published.find(params[:id])
  end
end
