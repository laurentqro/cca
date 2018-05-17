class Subscription < ApplicationRecord
  belongs_to :subscribeable, polymorphic: true
  belongs_to :subscriber, class_name: "User", foreign_key: "user_id"
end
