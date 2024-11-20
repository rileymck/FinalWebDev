class AddDefaultToChatsHistory < ActiveRecord::Migration[7.1]
  def change
    change_column_default :chats, :history, {}
  end
end
