# frozen_string_literal: true

class Notification < ApplicationRecord
  validates :action, presence: true

  belongs_to :user
  belongs_to :actor, class_name: '::User'
  belongs_to :target, polymorphic: true

  enum action: { created: 0, updated: 1, expiring: 2, mentioned: 3, resolved: 4, reopened: 5 }
end
