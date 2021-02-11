class AddVotesToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :votes, foreign_key: true
  end
end
