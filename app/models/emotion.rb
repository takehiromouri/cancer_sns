class Emotion < ApplicationRecord  
  belongs_to :user
  belongs_to :post, polymorphic: true, foreign_key: "post_id", counter_cache: true

  validates :user_id, uniqueness: {scope: :post_id}
  validates :user_id, :post_id, :emotion, presence: true

  enum emotion: {like: 0, happy: 1, sad: 2, mad: 3} 

  delegate :photo, to: :user, prefix: true

  after_create :create_notification
  after_create :increment_counter!

  private 

  def increment_counter!
    post["#{emotion.pluralize}_count"] += 1
    post.save
  end

  def create_notification
    Notification.create({ recipient: post.user, actor: user, action: "反応", notifiable: post }) if user != post.user
  end
end
