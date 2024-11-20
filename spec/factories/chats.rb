FactoryBot.define do
  factory :chat do
    user { nil }
    history { "" }
    q_and_a { "MyString" }
  end
end
