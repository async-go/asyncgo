class Vote < ApplicationRecord
    belongs_to :user
    belongs_to :comment
    has_one :emoji
end
