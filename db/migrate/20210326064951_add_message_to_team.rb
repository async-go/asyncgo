# frozen_string_literal: true

class AddMessageToTeam < ActiveRecord::Migration[6.1]
  def change
    change_table :teams, bulk: true do |t|
      t.string :message
    end
  end
end
