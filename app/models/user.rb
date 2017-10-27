class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  validates :username, uniqueness: true, presence: true
  validates :first_name, :last_name, :company, :city, presence: true

  def self.fetch_by_username_or_email(identifier)
    User.where('username LIKE :identifier OR email LIKE :identifier', identifier: identifier).first
  end
end
