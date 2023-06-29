class AddHoursToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :start_hours, :datetime
    add_column :events, :end_hours, :datetime
    remove_column :events, :date, :date
  end
end
