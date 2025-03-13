class TweetsController < ApplicationController
  
  def index
    current_page = 1
    per_page = 10

    current_page = search_params[:page]&.to_i if search_params[:page].present?
    per_page = search_params[:per_page]&.to_i if search_params[:per_page].present?
    username = search_params[:user_username] if search_params[:user_username].present?
    
    tweets_quantity_visible = current_page * per_page

    tweets = Tweet
                .newest
                .by_user(username)
                .limit(tweets_quantity_visible)

    next_page = current_page + 1

    render json: {
      tweets: tweets.as_json(only: [:id, :body, :created_at, :user_id]),
      next_page: next_page
    }
  end

  private

  def search_params
    params.permit(:per_page, :page, :user_username)
  end
end
