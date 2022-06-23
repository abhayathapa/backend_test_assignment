require 'rails_helper'

RSpec.describe Car, type: :model do
  subject do
    described_class.new(model: 'NSX',
                        price: 20_000,
                        brand: Brand.create(name: 'A'))
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a model' do
    subject.model = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a price' do
    subject.price = nil
    expect(subject).to_not be_valid
  end

  describe 'Associations' do
    it { should belong_to(:brand) }
  end
end
