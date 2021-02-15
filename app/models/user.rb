# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: { allow_blank: false }, uniqueness: true
  validates :name, presence: { allow_blank: false, allow_empty: false, allow_nil: true }
  validates :user_preference, presence: true

  belongs_to :team, optional: true

  has_many :comments, dependent: :destroy
  has_many :topics, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_topics, through: :subscriptions, source: :topic

  has_many :notifications, dependent: :destroy, inverse_of: :user
  has_many :votes, dependent: :destroy

  has_one :user_preference, dependent: :destroy

  def self.from_omniauth(access_token)
    User.where(email: access_token.info['email']).first_or_initialize.tap do |user|
      user.user_preference ||= user.build_user_preference
      user.name = access_token.info['name']
      user.save!
    end
  end

  def gravatar_url
    "https://www.gravatar.com/avatar/#{email_hash}"
  end

  def printable_name
    name || email
  end

  private

  def email_hash
    Digest::MD5.hexdigest(email.strip.downcase)
  end
end
