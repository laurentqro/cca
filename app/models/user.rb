class User < ApplicationRecord
  validates :username, :first_name, :last_name,
            :email, :company, :city,
            presence: true

  validates :email, uniqueness: true
end
