require 'rails_helper'

RSpec.describe "chats/index", type: :view do
  before(:each) do
    assign(:chats, [
      Chat.create!(
        user: nil,
        history: "",
        q_and_a: "Q And A"
      ),
      Chat.create!(
        user: nil,
        history: "",
        q_and_a: "Q And A"
      )
    ])
  end

  it "renders a list of chats" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Q And A".to_s), count: 2
  end
end
