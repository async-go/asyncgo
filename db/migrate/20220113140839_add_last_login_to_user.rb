# frozen_string_literal: true

class AddLastLoginToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_login, :datetime, default: nil, null: true
    User.all.each do |user|
      user.update!(last_login: user.updated_at)
    end
  end
end
