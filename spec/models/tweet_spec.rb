require 'rails_helper'

RSpec.describe Tweet, type: :model do
  RSpec.shared_context 'with several tweets' do
    let!(:company_1) { create(:company) }
    let!(:users) { create_list(:user, 5, company: company_1) }

    before do
      users.each { |user| create_list(:tweet, 10, user: user) }
    end

    let!(:tweets) { Tweet.all }
  end

  describe "scopes" do
    include_context 'with several tweets'

    context ".newest" do
      it "returns the most recent tweets" do
        expect(Tweet.newest.first.id).to eq(tweets.newest.first.id)
      end
    end

    context ".oldest" do
      it "returns the most old tweets" do
        expect(Tweet.oldest.first.id).to eq(tweets.first.id)
      end
    end

    context ".by_user" do
      it "returns the tweets filtered by index if current index exist" do
        per_page = 10
        current_page = 1
        tweets_quantity_visible = current_page * per_page

        expect(Tweet.newest.by_index(last_index_to_get, current_index).first.id).to eq(tweets.order(created_at: :desc).where("id >= ?", last_index_to_get).first.id)
      end
    end
  end
end
