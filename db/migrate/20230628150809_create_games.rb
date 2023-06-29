class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :publish_year
      t.text :description
      t.integer :min_players
      t.integer :max_players
      t.integer :duration

      t.timestamps
    end
  end
end
