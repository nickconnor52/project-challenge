require "rails_helper"

RSpec.feature "Home page", :type => :feature do
  scenario "New user lands on site" do
    2.times { create(:dog) }

    visit "/dogs?current_page=1"

    expect(page).to have_selector('.dog-photo', count: 2)
    expect(page).to have_selector('.dog-name', count: 2)
    expect(page).to have_selector('.advertisement')

    expect(page).to have_text("Sign in")
    expect(page).to have_text("Sign up")
  end
end
