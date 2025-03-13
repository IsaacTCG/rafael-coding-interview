require 'rails_helper'

RSpec.describe "Tweets", type: :request do
  RSpec.shared_context 'with several tweets' do
    let!(:company_1) { create(:company) }
    let!(:users) { create_list(:user, 5, company: company_1) }

    before do
      users.each { |user| create_list(:tweet, 10, user: user) }
    end

    let!(:tweets) { Tweet.all }
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body) }

    context 'when fetching all tweets' do
      include_context 'with several tweets'

      it 'returns most recent tweets with default per_page and page 1' do
        get tweets_path
        
        current_page = 1
        per_page = 10
        tweets_quantity_visible = current_page * per_page

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).limit(tweets_quantity_visible).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).limit(tweets_quantity_visible).ids)
      end
      
      it 'returns most recent tweets with specific per_page and page 1' do
        get tweets_path params: { per_page: 5 }
        
        current_page = 1
        per_page = 5
        tweets_quantity_visible = current_page * per_page

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).limit(tweets_quantity_visible).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).limit(tweets_quantity_visible).ids)
      end

      it 'returns most recent tweets with specific per_page and page 3' do
        get tweets_path params: { per_page: 5, page: 3 }
        
        current_page = 3
        per_page = 5
        tweets_quantity_visible = current_page * per_page

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).limit(tweets_quantity_visible).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).limit(tweets_quantity_visible).ids)
      end

      it 'the next_page return nil if the last tweet is the last of all' do
        get tweets_path params: { per_page: 10, page: 5 }
        
        current_page = 5
        per_page = 10
        tweets_quantity_visible = current_page * per_page

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:next_page]).to eq(nil)
      end
      
      it 'returns most recent tweets with default per_page, page 1 and with a username' do
        get user_tweets_path(users.first.username)


        current_page = 1
        per_page = 10
        username = users.first.username
        tweets_quantity_visible = current_page * per_page

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).where(user_id: User.find_by(username: username)&.id).limit(tweets_quantity_visible).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).where(user_id: User.find_by(username: username)&.id).limit(tweets_quantity_visible).ids)
      end
      
      it 'returns most recent tweets with specific per_page, page 3 and with a username' do
        get user_tweets_path(users.first.username), params: {per_page: 5, page: 3 }
        
        current_page = 3
        per_page = 5
        username = users.first.username
        tweets_quantity_visible = current_page * per_page

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).where(user_id: User.find_by(username: username)&.id).limit(tweets_quantity_visible).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).where(user_id: User.find_by(username: username)&.id).limit(tweets_quantity_visible).ids)
      end
      
      it 'the next_page return nil if the last tweet is the last of user' do
        get user_tweets_path(users.first.username), params: { per_page: 10, page: 4 }
        
        current_page = 5
        per_page = 10
        username = users.first.username
        tweets_quantity_visible = current_page * per_page

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:next_page]).to eq(nil)
      end
    end
  end
end
