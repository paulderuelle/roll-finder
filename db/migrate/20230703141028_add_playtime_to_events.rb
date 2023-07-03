class AddPlaytimeToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :playtime, :integer
    remove_column :events, :end_hours, :datetime
  end
end
