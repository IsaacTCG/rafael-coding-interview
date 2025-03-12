require 'rails_helper'

RSpec.describe "Users", type: :request do

  RSpec.shared_context 'with multiple companies' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times { create(:user, company: company_1) }
      5.times { create(:user, company: company_2) }
    end

    let!(:users) { User.all }
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body) }

    context 'when fetching users by company' do
      include_context 'with multiple companies'

      it 'returns only the users for the specified company' do
        get company_users_path(company_1)
        
        expect(result.size).to eq(company_1.users.size)
        expect(result.map { |element| element['id'] }).to eq(company_1.users.ids)
      end

      it "returns an empty result when no match for company_id is found" do
        get company_users_path('INVALID_IDENTIFIER')
        
        expect(result).to be_empty
        expect(result.size).to eq(0)
      end

      it 'returns all the users with specified username' do
        get company_users_path(company_1), params: { username: company_1.users.first.display_name }

        expect(result.size).to eq(company_1.users.where(display_name: company_1.users.first.display_name).count)
        expect(result.map { |element| element['id'] }).to match_array(company_1.users.where(display_name: company_1.users.first.display_name).pluck(:id)) 
      end
      
      it 'returns all the users with partial username' do
        get company_users_path(company_2), params: { username: company_2.users.first.display_name[0..2] }

        expect(result.size).to eq(company_2.users.where('LOWER(display_name) LIKE LOWER(?)', "%#{company_2.users.first.display_name[0..2]}%").count)
        expect(result.map { |element| element['id'] }).to match_array(company_2.users.where('LOWER(display_name) LIKE LOWER(?)', "%#{company_2.users.first.display_name[0..2]}%").pluck(:id)) 
      end
    end

    context 'when fetching all users' do
      include_context 'with multiple companies'

      it 'returns all the users' do
        get users_path

        expect(result.size).to eq(users.size)
        expect(result.map { |element| element['id'] }).to eq(users.ids)
      end

      it 'returns all the users with specified username' do
        get users_path, params: { username: company_1.users.first.display_name }

        expect(result.size).to eq(users.where(display_name: company_1.users.first.display_name).count)
        expect(result.map { |element| element['id'] }).to match_array(users.where(display_name: company_1.users.first.display_name).pluck(:id)) 
      end
      
      it 'returns all the users with partial username' do
        get users_path, params: { username: company_2.users.first.display_name[0..2] }

        expect(result.size).to eq(users.where('LOWER(display_name) LIKE LOWER(?)', "%#{company_2.users.first.display_name[0..2]}%").count)
        expect(result.map { |element| element['id'] }).to match_array(users.where('LOWER(display_name) LIKE LOWER(?)', "%#{company_2.users.first.display_name[0..2]}%").pluck(:id)) 
      end

      it "returns an empty result when no match is found" do
        get users_path, params: { username: 'NonexistentUser' }

        expect(result).to be_empty
        expect(result.size).to eq(0)
      end
    end
  end
end
