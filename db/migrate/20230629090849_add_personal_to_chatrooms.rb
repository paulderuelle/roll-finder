class AddPersonalToChatrooms < ActiveRecord::Migration[7.0]
  def change
    add_column :chatrooms, :personal, :boolean
  end
end
