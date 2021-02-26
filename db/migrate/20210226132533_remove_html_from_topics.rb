class RemoveHtmlFromTopics < ActiveRecord::Migration[6.1]
  def change
    remove_column :topics, :description_html
    remove_column :topics, :outcome_html
  end
end
