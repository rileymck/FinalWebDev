class User < ApplicationRecord

  has_many :chats, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



  #validataions
  #validates that email is present, unique, and in the correct format
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  #validates that password is at least 6 characters long
  #validates :password, length: { minimum: 6 }, if: Proc.new { new_record? || !password.nil? }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :password, confirmation: true



  def send_reset_password_instructions
    token = set_reset_password_token
    Rails.logger.debug "Generated reset password token: #{token}"
    send_devise_notification(:reset_password_instructions, token, {})
    token
  end

  def set_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    Rails.logger.debug "Stored reset password token: #{enc}"
    raw
  end
end
