require 'rails_helper'

describe 'Dog resource', type: :feature do
  include Devise::Test::IntegrationHelpers
  before(:each) do
    @user = create(:user)
    sign_in @user
  end
    
  it 'can create a profile' do
    visit new_dog_path
    fill_in 'Name', with: 'Speck'
    fill_in 'Description', with: 'Just a dog'
    attach_file 'Image', 'spec/fixtures/images/speck.jpg'
    click_button 'Create Dog'
    expect(Dog.count).to eq(1)
  end

  it 'can edit a dog profile' do
    dog = create(:dog)
    visit edit_dog_path(dog)
    fill_in 'Name', with: 'Speck'
    click_button 'Update Dog'
    expect(dog.reload.name).to eq('Speck')
  end

  it 'can delete a dog profile' do
    dog = create(:dog)
    visit dog_path(dog)
    click_link "Delete #{dog.name}'s Profile"
    expect(Dog.count).to eq(0)
  end

  it 'can associate an owner to a pup' do
    visit new_dog_path
    fill_in 'Name', with: 'Speck'
    fill_in 'Description', with: 'Just a dog'
    fill_in 'Owner\'s Email:', with: 'nickconnor52@gmail.com'
    attach_file 'Image', 'spec/fixtures/images/speck.jpg'
    click_button 'Create Dog'
    speck = Dog.find_by(name: 'Speck')
    expect(speck.user.id).to eq(@user.id)
  end

  it 'cannot edit the profile of a dog that is not yours' do
    dog = create(:dog, user_id: 2)
    visit edit_dog_path(dog)
    expect(page).to have_text("Delete Good Pup 12's Profile")
  end
end
