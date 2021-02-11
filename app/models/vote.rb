# frozen_string_literal: true

class Vote < ApplicationRecord
  validates :emoji, presence: { allow_blank: false }

  belongs_to :user
  belongs_to :comment
end
