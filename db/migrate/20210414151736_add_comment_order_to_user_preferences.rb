class AddCommentOrderToUserPreferences < ActiveRecord::Migration[6.1]
  def change
    add_column :user_preferences, :comment_order, :boolean, default: false, null: false
  end
end
