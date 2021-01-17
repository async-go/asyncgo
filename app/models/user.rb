# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: { allow_blank: false }, uniqueness: true

  belongs_to :team, optional: true

  has_many :comments, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_topics, through: :subscriptions, source: :topic

  def self.from_omniauth(access_token)
    User.where(email: access_token.info['email']).first_or_create
  end
end
