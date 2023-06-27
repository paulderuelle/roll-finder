class Bookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.text :comment
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
