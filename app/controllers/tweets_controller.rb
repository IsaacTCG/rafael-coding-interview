class TweetsController < ApplicationController
  
  def index
    per_page = 5
    current_index = Tweet.last.id

    per_page = search_params[:per_page]&.to_i if search_params[:per_page].present?
    current_index = search_params[:next_index]&.to_i if search_params[:next_index].present?

    last_index_to_get = current_index - (per_page - 1)

    tweets = Tweet
                .newest
                .by_index(last_index_to_get, current_index)
    
    next_index = last_index_to_get - 1
    next_index = nil if next_index < 1

    render json: {
      tweets: tweets.as_json(only: [:id, :content, :created_at, :user_id]),
      next_index: next_index
    }
  end

  private

  def search_params
    params.permit(:per_page, :next_index)
  end
end
