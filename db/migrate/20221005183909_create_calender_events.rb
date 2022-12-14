class CreateCalenderEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :calender_events do |t|
      t.references :listing, null: false, foreign_key: true
      t.integer :status, null: false 
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.references :reservation, null: true, foreign_key: true

      t.timestamps
    end
  end
end
