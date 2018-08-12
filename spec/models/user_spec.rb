# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should validate_length_of(:username).is_at_least(3).is_at_most(20) }

  describe '#username_regex' do
    let(:user) { FactoryGirl.build(:user) }
    it 'should not allow username with number at the beginning' do
      user.username = '9asdwe'
      expect(user.valid?).to be_falsy
    end

    it 'should not contain special caracters' do
      user.username = 'aswra*'
      expect(user.valid?).to be_falsy
    end
  end
end
