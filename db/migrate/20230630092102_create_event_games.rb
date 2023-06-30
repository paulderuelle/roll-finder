class CreateEventGames < ActiveRecord::Migration[7.0]
  def change
    create_table :event_games do |t|
      t.integer :event_id
      t.integer :game_id

      t.timestamps
    end
    add_index :event_games, :event_id
    add_index :event_games, :game_id
  end
end
