class AddPriceToListing < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :nighty_price, :integer
    add_column :listings, :cleaning_fee, :integer
  end
end
