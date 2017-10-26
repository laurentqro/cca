class User < ApplicationRecord
  validates :username, :first_name, :last_name,
            :email, :company, :city,
            presence: true

  validates :email, uniqueness: { case_sensitive: false }
end
