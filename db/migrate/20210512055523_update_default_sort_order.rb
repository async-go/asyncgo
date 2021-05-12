class UpdateDefaultSortOrder < ActiveRecord::Migration[6.1]
  def change
    change_column_default :user_preferences, :inverse_comment_order, from: false, to: true
  end
end
