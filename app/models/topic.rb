# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :title, presence: { allow_blank: false }
  validates :description, presence: { allow_blank: false }
  validates :decision, presence: { allow_blank: false, allow_empty: false, allow_nil: true }

  belongs_to :user
  belongs_to :team
  has_many :comments, dependent: :destroy
end
