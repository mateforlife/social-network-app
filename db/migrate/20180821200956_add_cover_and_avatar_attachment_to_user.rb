class AddCoverAndAvatarAttachmentToUser < ActiveRecord::Migration[5.2]
  def change
    add_attachment :users, :avatar
    add_attachment :users, :cover
  end
end
