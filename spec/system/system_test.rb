require 'rails_helper'

RSpec.describe 'User Sign Up and Login', type: :system do
    describe "Student Registration" do
        # New user with correct information
        context "new user with correct information" do
            it "allows a user to sign up" do
                visit new_user_registration_path
                fill_in "Email", with: "cr@msudenver.edu"
                fill_in "Password", with: "password"    
                fill_in "Password confirmation", with: "password"
                click_button "Sign up"
                expect(page).to have_content("")
            end
       # New user with incorrect information
       end
    end 
end