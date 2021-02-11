# frozen_string_literal: true

class Emoji < ApplicationRecord
  validates :name, :character, presence: true
end
