# frozen_string_literal: true

class AddVotesToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :votes, :comments, foreign_key: true
  end
end
