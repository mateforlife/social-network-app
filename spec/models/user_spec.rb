# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  username               :string
#  name                   :string
#  uid                    :string
#  provider               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  about                  :text
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :bigint(8)
#  avatar_updated_at      :datetime
#  cover_file_name        :string
#  cover_content_type     :string
#  cover_file_size        :bigint(8)
#  cover_updated_at       :datetime
#


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
