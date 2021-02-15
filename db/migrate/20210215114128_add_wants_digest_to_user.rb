# frozen_string_literal: true

class AddWantsDigestToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :wants_digests, :boolean, default: true
  end
end
