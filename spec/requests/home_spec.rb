require 'rails_helper'

RSpec.describe 'Home', type: :request do
  let!(:brand_1) { Brand.create(name: 'Acura') }
  let!(:brand_2) { Brand.create(name: 'Alfa Romeo') }
  let!(:brand_3) { Brand.create(name: 'Audi') }
  let!(:brand_4) { Brand.create(name: 'BMW') }
  let!(:car_1) { Car.create(id: 5, model: 'NSX', brand: brand_1, price: 16_841) }
  let!(:car_2) { Car.create(id: 13, model: 'RSX', brand: brand_2, price: 36_000) }
  let!(:car_3) { Car.create(model: 'ILX', brand: brand_2, price: 38_000) }
  let!(:user) { User.create(email: 'example@mail.com', preferred_price_range: 35_000...40_000) }

  context 'when rank list API is not working' do
    before do
      allow_any_instance_of(User).to receive(:recommended_cars).and_return(nil)
    end

    it 'provides error message' do
      post '/search', params: { "user_id": user.id, "page": 1 }
      expect(JSON.parse(response.body)).to eq({ 'Error' => 'Car API service unavailable' })
    end
  end

  context 'when rank list api is working' do
    before do
      UserPreferredBrand.create(user: user, brand: brand_1)
      UserPreferredBrand.create(user: user, brand: brand_2)
      allow_any_instance_of(User).to receive(:recommended_cars).and_return([
                                                                             { "car_id": car_1.id,
                                                                               "rank_score": 0.945 },
                                                                             { "car_id": car_2.id,
                                                                               "rank_score": 0.4552 },
                                                                             { "car_id": 13, "rank_score": 0.567 }
                                                                           ])
    end

    it 'provides correct response code' do
      post '/search', params: { "user_id": user.id, "page": 1 }
      expect(response).to have_http_status(:ok)
    end

    it 'provides list of cars with correct attributes' do
      post '/search', params: { "user_id": user.id, "page": 1 }
      expect(JSON.parse(response.body).first.keys).to eq %w[id brand price rank_score model label]
    end

    it 'provides sorted list of cars' do
      post '/search', params: { "user_id": user.id, "page": 1 }
      expect(JSON.parse(response.body).first['label']).to eq 'perfect_match'
    end
  end
end
