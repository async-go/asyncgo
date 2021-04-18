# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: { allow_blank: false },
                    uniqueness: { case_sensitive: false }, length: { minimum: 4, maximum: 254 },
                    format: { with: /\A(.+)@(.+)\z/ }
  validates :name, presence: { allow_blank: false, allow_empty: false, allow_nil: true }
  validates :preference, presence: true

  belongs_to :team, optional: true

  has_many :comments, dependent: :destroy
  has_many :topics, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_topics, through: :subscriptions, source: :topic

  has_many :notifications, inverse_of: :user, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_one :preference, class_name: 'User::Preference', dependent: :destroy

  def self.from_omniauth(email, name)
    User.where(email: email).first_or_initialize.tap do |user|
      user.preference ||= user.build_preference
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

  def clear_topic_notifications(topic)
    notifications.where(read_at: nil, target: topic.comments)
                 .or(notifications.where(read_at: nil, target: topic))
                 .update(read_at: Time.now.utc)
  end

  private

  def email_hash
    Digest::MD5.hexdigest(email.strip.downcase)
  end
end
