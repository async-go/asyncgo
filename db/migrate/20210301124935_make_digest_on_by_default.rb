# frozen_string_literal: true

class MakeDigestOnByDefault < ActiveRecord::Migration[6.1]
  def change
    change_column(:user_preferences, :digest_enabled, :boolean, default: true, null: false)
  end
end
