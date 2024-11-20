require 'rails_helper'

RSpec.describe "chats/show", type: :view do
  before(:each) do
    assign(:chat, Chat.create!(
      user: nil,
      history: "",
      q_and_a: "Q And A"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Q And A/)
  end
end
