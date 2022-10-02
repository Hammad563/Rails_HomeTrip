class ListingsController < ApplicationController
  def index
    @listings = Listing.with_published
  end

  def show
    @listing = Listing.with_published.find(params[:id])
  end
end
