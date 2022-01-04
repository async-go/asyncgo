# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: { allow_blank: false },
                    uniqueness: { case_sensitive: false }, length: { minimum: 4, maximum: 254 },
                    format: { with: /\A(.+)@(.+)\z/ }
  validates :name, presence: { allow_blank: false, allow_empty: false, allow_nil: true }
  validates :preferences, presence: true

  belongs_to :team, optional: true

  has_many :comments, dependent: :destroy
  has_many :topics, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_topics, through: :subscriptions, source: :topic

  has_many :notifications, inverse_of: :user, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_one :preferences, class_name: 'User::Preferences', dependent: :destroy

  def self.from_omniauth(email, name)
    User.where(email:).first_or_initialize.tap do |user|
      user.preferences ||= user.build_preferences
      user.name = name
      user.save!
    end
  end

  def gravatar_url
    "https://www.gravatar.com/avatar/#{email_hash}"
  end

  def printable_name
    name || email
  end

  def topic_notifications(topic)
    notifications.where(read_at: nil, target: topic.comments)
                 .or(notifications.where(read_at: nil, target: topic))
  end

  def clear_topic_notifications(topic)
    topic_notifications(topic).update(read_at: Time.now.utc)
  end

  private

  def email_hash
    Digest::MD5.hexdigest(email.strip.downcase)
  end
end
