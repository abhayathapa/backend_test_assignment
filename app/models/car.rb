class Car < ApplicationRecord
  belongs_to :brand

  validates_presence_of :model, :price
end
