# == Schema Information
#
# Table name: friendships
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  friend_id  :bigint(8)
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :friendship do
    association :user, factory: :user
    association :friend, factory: :user
    status "MyString"
  end
end
