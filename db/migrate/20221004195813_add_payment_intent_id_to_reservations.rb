class AddPaymentIntentIdToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :payment_intent_id, :string
  end
end
