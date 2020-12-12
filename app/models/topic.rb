# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :title, presence: { allow_blank: false }

  belongs_to :user
  has_many :comments, dependent: :destroy
end
