require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'Associations' do
    it { should have_many(:cars) }
  end
end
