require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(described_class.new).to be_valid
  end

  describe 'Associations' do
    it { should have_many(:preferred_brands) }
    it { should have_many(:user_preferred_brands) }
  end

  describe '#label' do
    let!(:brand_1) { Brand.create(name: 'Acura') }
    let!(:brand_2) { Brand.create(name: 'Alfa Romeo') }
    let!(:car_1) { Car.create(id: 5, model: 'NSX', brand: brand_1, price: 36_841) }
    let!(:car_2) { Car.create(id: 13, model: 'RSX', brand: brand_2, price: 36_000) }
    let!(:user) { User.create(email: 'example@mail.com', preferred_price_range: 35_000...40_000) }

    before do
      UserPreferredBrand.create(user: user, brand: brand_1)
    end

    it 'returns proper label' do
      expect(user.label(car_1)).to eq 'perfect_match'
      expect(user.label(car_2)).to be nil
    end
  end
end
