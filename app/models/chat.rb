class Chat < ApplicationRecord
  belongs_to :user
  validates :history, presence: true
end
