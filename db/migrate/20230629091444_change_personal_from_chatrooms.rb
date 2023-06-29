class ChangePersonalFromChatrooms < ActiveRecord::Migration[7.0]
  def change
    change_column :chatrooms, :personal, :boolean, null: false
  end
end
