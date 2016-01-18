require 'rails_helper'

describe 'Signing Up' do
  it 'allows a user to sign up for the site & creates the object in the database' do
    expect(User.count).to eq(0)

    visit '/'
    expect(page).to have_content('Sign Up')
    click_link 'Sign Up'

    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email', with: 'john@doe.com'
    fill_in 'Password', with: 'password1234'
    fill_in 'Password confirmation', with: 'password1234'
    click_button 'Sign Up'

    expect(User.count).to eq(1)
  end
end
