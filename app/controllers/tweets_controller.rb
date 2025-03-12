class TweetsController < ApplicationController
  
  def index
    per_page = 5
    next_index = Tweet.last.id

    per_page = search_params[:per_page]&.to_i if search_params[:per_page].present?
    next_index = search_params[:next_index]&.to_i if search_params[:next_index].present?

    next_last_tweet_index_by_per_page = next_index - (per_page - 1)

    tweets = Tweet.order(created_at: :desc)
    tweets = tweets.where("id >= ?", next_last_tweet_index_by_per_page) if next_index.present? && next_index.positive?
    
    next_index = next_last_tweet_index_by_per_page - 1
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
