require 'rails_helper'

RSpec.describe 'User Sign Up and Login', type: :system do
  before do
    driven_by(:rack_test) # Use the default rack_test driver
  end

  context 'when using valid credentials' do
    it 'allows the user to sign up and log in' do
      visit new_user_registration_path

      # Fill out the sign-up form
      fill_in 'user_email', with: 'test@example.com'
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'password123'
      click_button 'Sign up'

      # Expect to see success message and be logged in
      expect(page).to have_content('Welcome! You have signed up successfully.')

      # Expect the logout form to be present
      expect(page).to have_button('Sign Out')
    end
  end

  context 'when using invalid credentials' do
    it 'does not allow the user to sign up or log in' do
      visit new_user_registration_path

      # Fill out the sign-up form with invalid data
      fill_in 'user_email', with: 'invalid-email'
      fill_in 'user_password', with: 'short1'
      fill_in 'user_password_confirmation', with: 'mismatch'
      click_button 'Sign up'

      # Expect to see validation error messages
      expect(page).to have_content('Email is invalid')
      expect(page).to have_content('Password is too short (minimum is 6 characters)')
      expect(page).to have_content("Password confirmation doesn't match Password")

      # Ensure the logout button is not present
      expect(page).to_not have_button('Sign Out')
    end
  end
end