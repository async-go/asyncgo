class ChangeUserEmailToCaseInsensitive < ActiveRecord::Migration[6.1]
  def change
    enable_extension :citext
    change_column :users, :email, :citext
  end
end
