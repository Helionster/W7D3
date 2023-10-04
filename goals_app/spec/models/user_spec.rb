# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it {should validate_presence_of (:username)}
  it {should validate_presence_of (:password_digest)}
  it {should validate_length_of(:password).is_at_least(6)}
  it {should validate_presence_of (:session_token)}

  describe 'unqiueness' do 
    before :each do 
      FactoryBot.create(:user)
    end

    it {should validate_uniqueness_of (:username)}
    it {should validate_uniqueness_of (:session_token)}
  end

  describe "is_password" do
    let(:user) {FactoryBot.create(:user,password: '1234567')}

    context "with a valid password" do 
      it "should return true" do 
        expect(user.is_password?('1234567')).to be true
      end
    end

    context "with a invalid password" do 
      it "should return false" do 
        expect(user.is_password?('123567')).to be false
      end
    end
  end

  describe "find_by_credentials" do 
    subject(:user) {FactoryBot.create(:user, username: 'balaji', password: 'password')}

    context "if found user return user" do 
      it "should return user" do 
        expect(User.find_by_credentials('balaji','password')).not_to be_nil
      end
    end

    context "if not found user return nil" do 
      it "should return nil" do 
        expect(User.find_by_credentials('jason','password')).to be_nil
      end
    end
  end

  describe "ensure_session_token" do 
    let(:second) { FactoryBot.build(:user, session_token: nil) }

    before :each do 
      second.ensure_session_token
    end

    context "if session token doesnt exist set session token" do 
      it "shouldnt return nil" do 
        expect(second.session_token).not_to be_nil
      end
    end
  end
end


