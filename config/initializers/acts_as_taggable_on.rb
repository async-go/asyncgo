# frozen_string_literal: true

require './lib/asyncgo_tag_parser'

ActsAsTaggableOn.default_parser = AsyncgoTagParser
