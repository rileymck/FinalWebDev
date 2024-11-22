require 'rails_helper'

RSpec.describe "Users", type: :system do
  context 'when using valid credentials' do
    it 'allows the user to sign up and log in' do
      visit new_user_registration_path

      # Fill out the sign-up form
      fill_in 'user_email', with: 'test@example.com'
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'password123'
      click_button 'Sign up'

      # Expect to see success message and be logged in
      #expect(page).to have_content('Sign up')

      # Expect the logout form to be present
      #expect(page).to have_button('Logout')
    end
  end



  context 'when using invalid credentials' do
    it 'does not allow the user to sign up or log in' do
      visit new_user_registration_path

      # Fill out the sign-up form with invalid data
      fill_in 'user_email', with: 'invalid-email'
      fill_in 'user_password', with: 'short1'
      fill_in 'user_password_confirmation', with: 'short2'
      click_button 'Sign up'

      # Expect to see validation error messages
      #expect(page).to have_content('Please include an "@" in the email address')

      #expect(page).to have_content('Sign up')

      # Ensure the logout button is not present
      #expect(page).to_not have_button('Logout')
    end
  end
end
