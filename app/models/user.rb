# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: { allow_blank: false }

  belongs_to :team, optional: true
end
