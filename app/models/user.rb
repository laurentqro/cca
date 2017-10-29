class User < ApplicationRecord
  has_secure_password

  has_many :assignments
  has_many :projects, through: :assignments

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  validates :username, uniqueness: true, presence: true
  validates :first_name, :last_name, :company, :city, presence: true

  def self.fetch_by_username_or_email(identifier)
    User.where('username LIKE :identifier OR email LIKE :identifier', identifier: identifier).first
  end

  def self.unassigned_to_project(project_id)
    User
      .joins("LEFT OUTER JOIN assignments ON assignments.user_id = users.id AND assignments.project_id = #{project_id}")
      .where('assignments.id IS NULL')
  end

  def User.digest(string)
    BCrypt::Password.create(string, cost: bcrypt_cost)
  end

  private

  def bcrypt_cost
    ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  end
end
