require 'rails_helper'

RSpec.describe "chats/edit", type: :view do
  let(:chat) {
    Chat.create!(
      user: nil,
      history: "",
      q_and_a: "MyString"
    )
  }

  before(:each) do
    assign(:chat, chat)
  end

  it "renders the edit chat form" do
    render

    assert_select "form[action=?][method=?]", chat_path(chat), "post" do

      assert_select "input[name=?]", "chat[user_id]"

      assert_select "input[name=?]", "chat[history]"

      assert_select "input[name=?]", "chat[q_and_a]"
    end
  end
end
