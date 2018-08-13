require 'rails_helper'

RSpec.describe DogsController, type: :controller do
  describe '#index' do
    it 'displays recent dogs' do
      2.times { create(:dog) }
      get :index
      expect(assigns(:dogs).size).to eq(2)
    end
    it 'displays 5 dogs per page' do
      7.times { create(:dog) }
      get :index
      expect(assigns(:current_dogs).size).to eq(5)
    end
  end
end
