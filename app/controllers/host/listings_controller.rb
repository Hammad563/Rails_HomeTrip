class Host::ListingsController < ApplicationController
  def index
    @listings = current_user.listings.all
  end
  
  def new
    @listing = Listing.new
  end

  def create 
    @listing = current_user.listings.new(listing_params)
    #@listing.host_id = current_user.id
    if @listing.save
      redirect_to host_listing_path(@listing)
    else
      flash.now[:errors] = @listing.errors.full_messages
      render :new
    end 
  end

  def edit
    @listing = current_user.listings.find(params[:id])
  end

  def update
    @listing = current_user.listings.find(params[:id])
    if @listing.update(listing_update_params)
      redirect_to host_listing_path(@listing)
    else
      flash.now[:errors] = @listing.errors.full_messages
      render :edit
    end
  end

  def destroy
    @listing = current_user.listings.find(params[:id])
    @listing.update(status: :archived)
    redirect_to host_listings_path
  end

  def show
    @listing = current_user.listings.find(params[:id])
  end

  private

  def listing_params
    params.require(:listing).permit(:title, :about, :max_guests, :address_line1, :address_2, :city, :state, :postal_code, :country, :lat, :lng)
  end
  def listing_update_params
    params.require(:listing).permit(:title, :about, :max_guests)
  end
end
