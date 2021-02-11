class Emoji < ApplicationRecord
    validates :name, :character, presence: true
end
