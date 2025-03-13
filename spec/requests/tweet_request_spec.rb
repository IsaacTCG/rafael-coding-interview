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

      it 'returns most recent tweets with default per_page and without index' do
        get tweets_path
        
        default_per_page = 10
        last_index_to_get = tweets.last.id - (default_per_page - 1)

        next_index = last_index_to_get - 1
        next_index = nil if next_index < 1

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).ids)
      end
      
      it 'returns most recent tweets with specific per_page and without index' do
        get tweets_path params: { per_page: 5 }
        
        per_page = 5
        last_index_to_get = tweets.last.id - (per_page - 1)

        next_index = last_index_to_get - 1
        next_index = nil if next_index < 1

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).ids)
      end
      
      it 'returns most recent tweets with default per_page and with a next index' do
        get tweets_path params: { next_index: 30 }
        
        default_per_page = 10
        current_index = 30

        last_index_to_get = tweets.where(id: current_index).first.id - (default_per_page - 1)
        
        next_index = last_index_to_get - 1
        next_index = nil if next_index < 1

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).ids)
      end
      
      it 'returns most recent tweets with per_page and with a next index' do
        get tweets_path params: { per_page: 20, next_index: 30 }
        
        default_per_page = 20
        current_index = 30
        
        last_index_to_get = tweets.where(id: current_index).first.id - (default_per_page - 1)

        next_index = last_index_to_get - 1
        next_index = nil if next_index < 1

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).ids)
      end
      
      it 'the next_index return nil if is less than 1' do
        get tweets_path params: { per_page: 10, next_index: 10 }
        
        default_per_page = 10
        current_index = 10

        last_index_to_get = tweets.where(id: current_index).first.id - (default_per_page - 1)

        next_index = last_index_to_get - 1
        next_index = nil if next_index < 1

        result_hash = result.transform_keys(&:to_sym)

        expect(result_hash[:tweets].size).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).size)
        expect(result_hash[:tweets].map { |element| element['id'] }).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).ids)
        expect(result_hash[:next_index]).to eq(next_index)
      end
    end
  end
end
