# frozen_string_literal: true

class AsyncgoTagParser < ActsAsTaggableOn::GenericParser
  TAG_DELIMITERS = [',', ' '].freeze

  def parse
    ActsAsTaggableOn::TagList.new.tap do |tag_list|
      tag_list.add @tag_list.split(Regexp.union(TAG_DELIMITERS))
    end
  end
end
