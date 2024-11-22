require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe 'Validations' do
    context 'when fields are valid' do
      it 'is valid with a valid email and a password of at least 6 characters' do
        user = User.new(email: 'test@example.com', password: 'password123')
        expect(user).to be_valid
      end
    end

    context 'when email is missing' do
      it 'is invalid without an email' do
        user = User.new(email: nil, password: 'password123')
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end
    end

    context 'when email format is incorrect' do
      it 'is invalid with an improperly formatted email' do
        user = User.new(email: 'invalidemail', password: 'password123')
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include('is invalid')
      end
    end

    context 'when password is too short' do
      it 'is invalid with a password less than 6 characters' do
        user = User.new(email: 'test@example.com', password: 'short')
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end
    end
  end
end
