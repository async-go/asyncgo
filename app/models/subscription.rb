# frozen_string_literal: true

class Subscription < ApplicationRecord
  validates :topic_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :topic
end
