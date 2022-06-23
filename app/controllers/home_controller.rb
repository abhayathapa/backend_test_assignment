class HomeController < ApplicationController
  before_action :set_params

  def search
    user = User.find(params[:user_id])
    rank_list = user.recommended_cars
    if rank_list.present?
      cars = []
      car_ids = rank_list.map { |x| x['car_id'] }
      Car.ransack(id_in: car_ids).result.ransack(params[:q]).result.paginate(page: params[:page] || 1,
                                                                             per_page: 20).each do |car|
        if rank_list.select { |a| a['car_id'] == car.id }.present?
          score = rank_list.select do |a|
                    a['car_id'] == car.id
                  end.first['rank_score']
        end
        cars << {
          id: car.id,
          brand: { id: car.brand.id, name: car.brand.name },
          price: car.price,
          rank_score: score,
          model: car.model,
          label: user.label(car)
        }
      end
      cars.sort! do |a, b|
        [b[:label].to_s, b[:rank_score].to_i,
         a[:price].to_i] <=> [a[:label].to_s, a[:rank_score].to_i, b[:price].to_i]
      end
    else
      cars = { 'Error': 'Car API service unavailable' }
    end

    render json: cars
  end

  private

  def set_params
    params[:q] = {}
    params[:q][:price_lt] = params[:price_max] if params[:price_max]
    params[:q][:price_gt] = params[:price_min] if params[:price_min]
    params[:q][:brand_name_matches] = params[:query] if params[:query]
  end
end
