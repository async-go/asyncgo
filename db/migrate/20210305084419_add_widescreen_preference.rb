# frozen_string_literal: true

class AddWidescreenPreference < ActiveRecord::Migration[6.1]
  def change
    add_column :user_preferences, :widescreen_enabled, :boolean, default: true, null: false
  end
end
