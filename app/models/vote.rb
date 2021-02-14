# frozen_string_literal: true

class Vote < ApplicationRecord
  validates :emoji, presence: true
  validate :emoji_must_exist

  belongs_to :user
  belongs_to :votable, polymorphic: true

  private

  def emoji_must_exist
    return if Emoji.find_by_alias(emoji) # rubocop:disable Rails/DynamicFindBy

    errors.add(:emoji, 'must be a valid emoji alias')
  end
end
