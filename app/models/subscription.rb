class Subscription < ApplicationRecord
  belongs_to :subscribeable, polymorphic: true
end
