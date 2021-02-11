# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  has_one :emoji, dependent: :destroy
end
