class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  has_many :assignments
  has_many :projects, through: :assignments
  has_many :activities

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  validates :username, uniqueness: true, presence: true
  validates :first_name, :last_name, :city, presence: true

  enum group: [ :partner, :employee, :admin ]

  def self.fetch_by_username_or_email(identifier)
    User.where('username LIKE :identifier OR email LIKE :identifier', identifier: identifier).first
  end

  def self.unassigned_to_project(project_id)
    User
      .joins("LEFT OUTER JOIN assignments ON assignments.user_id = users.id AND assignments.project_id = #{project_id}")
      .where('assignments.id IS NULL')
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def company_name
    company.name
  end

  def account_status
    self.active? ? "actif" : "inactif"
  end

  def active_for_authentication?
    super && self.active?
  end
end
