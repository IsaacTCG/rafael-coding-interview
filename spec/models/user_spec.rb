require 'rails_helper'

RSpec.describe User, type: :model do
  RSpec.shared_context 'with multiple companies' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times { create(:user, company: company_1) }
      5.times { create(:user, company: company_2) }
    end

    let!(:users) { User.all }
  end

  describe "scopes" do
    include_context 'with multiple companies'

    context ".by_company" do
      it "returns users belonging to a specific company" do
        expect(User.by_company(company_1.id).pluck(:id)).to match_array(company_1.users.pluck(:id))
        expect(User.by_company(company_2.id).pluck(:id)).to match_array(company_2.users.pluck(:id))
      end
    end

    context ".by_username" do
      it "returns users whose display_name contains the search term" do
        search_name = company_1.users.first.display_name
        expect(User.by_username(search_name).pluck(:id)).to match_array(company_1.users.where("LOWER(display_name) LIKE LOWER(?)", "%#{search_name}%").pluck(:id))
      end

      it "is case-insensitive" do
        search_name = company_1.users.first.display_name.downcase
        expect(User.by_username(search_name).pluck(:id)).to match_array(company_1.users.where("LOWER(display_name) LIKE LOWER(?)", "%#{search_name}%").pluck(:id))
      end

      it "returns an empty result when no match is found" do
        expect(User.by_username("NonexistentUser")).to be_empty
      end
    end

    context "combining scopes" do
      it "returns users filtered by company and username" do
        search_name = company_1.users.first.display_name
        expect(User.by_company(company_1.id).by_username(search_name).pluck(:id)).to match_array(company_1.users.where("LOWER(display_name) LIKE LOWER(?)", "%#{search_name}%").pluck(:id))
      end
    end
  end
end
