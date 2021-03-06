class Emotion < ApplicationRecord  
  include ActiveModel::Dirty  

  belongs_to :user
  belongs_to :post, polymorphic: true, foreign_key: "post_id"

  validates :user_id, uniqueness: {scope: [:post]}
  validates :user_id, :post_id, :emotion, presence: true

  enum emotion: {like: 0, happy: 1, sad: 2, mad: 3} 

  scope :likes, ->(){ where(emotion: "like") }
  scope :happies, ->(){ where(emotion: "happy") }
  scope :sads, ->(){ where(emotion: "sad") }
  scope :mads, ->(){ where(emotion: "mad") }

  delegate :photo, to: :user, prefix: true

  after_create :create_notification
  after_create :increment_counter!
  after_create :increment_counter_cache!
  after_update :increment_counter!  
  after_destroy :decrement_counter!

  private

  def decrement_counter!
    post["#{emotion.pluralize}_count"] -= 1
    post.emotions_count -= 1
    post.save(touch: false)
  end

  def increment_counter!
    post["#{emotion.pluralize}_count"] += 1
    post.save(touch: false)
  end

  def increment_counter_cache!
    post.emotions_count += 1
    post.save(touch: false)
  end

  def create_notification
    if post.is_a? Comment
      Notification.create({ recipient: post.user, actor: user, action: "コメントに反応", notifiable: post.post }) if user != post.user
    else
      Notification.create({ recipient: post.user, actor: user, action: "反応", notifiable: post }) if user != post.user
    end
  end
end
