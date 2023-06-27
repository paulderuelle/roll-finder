class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.date :date
      t.string :address
      t.integer :slot_number
      t.boolean :online
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
