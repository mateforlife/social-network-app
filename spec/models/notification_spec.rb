# == Schema Information
#
# Table name: notifications
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  item_type  :string
#  item_id    :bigint(8)
#  viewed     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Notification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
