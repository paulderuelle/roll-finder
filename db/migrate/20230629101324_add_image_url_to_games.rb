class AddImageUrlToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :image_url, :string
  end
end
