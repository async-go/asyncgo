# frozen_string_literal: true

class Vote < ApplicationRecord
  validates :emoji, presence: true

  belongs_to :user
  belongs_to :votable, polymorphic: true
end
