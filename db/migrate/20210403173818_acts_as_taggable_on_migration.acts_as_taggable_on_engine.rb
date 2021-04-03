# frozen_string_literal: true

class ActsAsTaggableOnMigration < ActiveRecord::Migration[6.1]
  TAGS_TABLE = ActsAsTaggableOn.tags_table
  TAGGINGS_TABLE = ActsAsTaggableOn.taggings_table

  def self.up
    create_table TAGS_TABLE do |t|
      t.string :name, index: { unique: true }
      t.integer :taggings_count, default: 0

      t.timestamps
    end

    create_table TAGGINGS_TABLE do |t|
      t.references :tag, foreign_key: { to_table: TAGS_TABLE }, index: true

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, polymorphic: true
      t.references :tagger, polymorphic: true

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, limit: 128, index: true

      t.datetime :created_at

      t.index %i[tag_id taggable_id taggable_type context tagger_id tagger_type], unique: true,
                                                                                  name: 'taggings_idx'
      t.index %i[taggable_id taggable_type tagger_id context], name: 'taggings_idy'
      t.index %i[taggable_id taggable_type context], name: 'taggings_taggable_context_idx'
      t.index %i[tagger_id tagger_type]
    end
  end
end
