class User < ApplicationRecord
  has_many :user_preferred_brands, dependent: :destroy
  has_many :preferred_brands, through: :user_preferred_brands, source: :brand

  def label(car)
    brand_name = preferred_brands.include? car.brand
    price_range = preferred_price_range.include? car.price

    if brand_name && price_range
      'perfect_match'
    elsif brand_name
      'good_match'
    end
  end

  def recommended_cars
    response = HTTParty.get("https://bravado-images-production.s3.amazonaws.com/recomended_cars.json?user_id=#{id}")
    JSON.parse(response.body) if response.code == 200
  end
end
