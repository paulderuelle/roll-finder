class RemoveCommentsFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :comment, :text
  end
end
