require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  context 'validations' do
    it 'is valid with a valid email and a password of at least 6 characters' do
      user = User.new(email: 'test@example.com', password: 'password123')
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(email: nil, password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with an improperly formatted email' do
      user = User.new(email: 'invalidemail', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'is invalid with a password less than 6 characters' do
      user = User.new(email: 'test@example.com', password: 'short')
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end
end
