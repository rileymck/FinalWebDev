class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  #validataions
  #validates that email is present, unique, and in the correct format
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  #validates that password is at least 6 characters long
  validates :password, length: { minimum: 6 }, if: Proc.new { new_record? || !password.nil? }

end
