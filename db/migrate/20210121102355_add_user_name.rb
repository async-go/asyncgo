# frozen_string_literal: true

class AddUserName < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
  end
end
