# frozen_string_literal: true

# This migration comes from acts_as_taggable_on_engine (originally 5)
# This migration is added to circumvent issue #623 and have special characters
# work properly
class ChangeCollationForTagNames < ActiveRecord::Migration[6.1]
  # This was included in
  # 20210403173818_acts_as_taggable_on_migration.acts_as_taggable_on_engine.rb

  # no-op
end
