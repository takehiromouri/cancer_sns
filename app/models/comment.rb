class Comment < ApplicationRecord
	default_scope { order(created_at: :asc) }

	validates :text, :user_id, :post_id, presence: true
	belongs_to :user
	belongs_to :post, polymorphic: true

	delegate :photo, to: :user, prefix: true
	delegate :user, to: :post, prefix: true

  scope :visible, ->{ where(visible: true) }

  after_create :create_notifications

  def toggle_visibility!
    self.visible = !visible
    save
  end

  def delete!
    update(deleted_at: DateTime.now)
  end

  def deleted?
    deleted_at.present?
  end


  private

  def create_notifications
    post.comments.each do |comment|
      Notification.create({recipient: comment.user, actor: user, action: "コメント", notifiable: self.post}) unless (comment.user == self.user)
    end
    
    Notification.create({recipient: self.post.user, actor: self.user, action: "コメント", notifiable: self.post}) unless self.post.comments.pluck(:user_id).include?(self.post.user.id)
  end
end
