# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: '::User'
  belongs_to :target, polymorphic: true

  enum action: { created: 0, updated: 1 }
end
