# frozen_string_literal: true

class InitSchema < ActiveRecord::Migration[6.0]
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def up
    create_table 'comments' do |t|
      t.text 'body', null: false
      t.text 'body_html', null: false
      t.integer 'topic_id', null: false
      t.integer 'user_id', null: false
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.index ['topic_id'], name: 'index_comments_on_topic_id'
      t.index ['user_id'], name: 'index_comments_on_user_id'
    end
    create_table 'notifications' do |t|
      t.integer 'user_id', null: false
      t.integer 'actor_id', null: false
      t.string 'target_type', null: false
      t.integer 'target_id', null: false
      t.integer 'action', null: false
      t.date 'read_at'
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.index ['actor_id'], name: 'index_notifications_on_actor_id'
      t.index %w[target_type target_id], name: 'index_notifications_on_target'
      t.index ['user_id'], name: 'index_notifications_on_user_id'
    end
    create_table 'subscriptions' do |t|
      t.integer 'user_id'
      t.integer 'topic_id'
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.index ['topic_id'], name: 'index_subscriptions_on_topic_id'
      t.index %w[user_id topic_id], name: 'index_subscriptions_on_user_id_and_topic_id', unique: true
      t.index ['user_id'], name: 'index_subscriptions_on_user_id'
    end
    create_table 'teams' do |t|
      t.string 'name', null: false
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
    end
    create_table 'topics' do |t|
      t.string 'title', null: false
      t.text 'description', null: false
      t.text 'description_html', null: false
      t.text 'outcome'
      t.text 'outcome_html'
      t.integer 'user_id', null: false
      t.integer 'team_id', null: false
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.integer 'status', default: 0, null: false
      t.date 'due_date'
      t.index ['team_id'], name: 'index_topics_on_team_id'
      t.index ['user_id'], name: 'index_topics_on_user_id'
    end
    create_table 'users' do |t|
      t.string 'email', null: false
      t.integer 'team_id'
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.string 'name'
      t.index ['email'], name: 'index_users_on_email', unique: true
      t.index ['team_id'], name: 'index_users_on_team_id'
    end
    create_table 'votes' do |t|
      t.string 'emoji', null: false
      t.integer 'user_id', null: false
      t.string 'votable_type', null: false
      t.integer 'votable_id', null: false
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.index ['user_id'], name: 'index_votes_on_user_id'
      t.index %w[votable_type votable_id], name: 'index_votes_on_votable'
    end
    add_foreign_key 'votes', 'users'
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'The initial migration is not revertable'
  end
end
