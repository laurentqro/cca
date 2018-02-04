class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :assignments
  has_many :projects, through: :assignments
  has_many :activities
  has_many :folders, through: :projects
  has_many :employments
  has_many :companies, through: :employments

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  validates :first_name, :last_name, :city, presence: true

  enum group: [ :partner, :employee, :admin ]

  def self.unassigned_to_project(project_id)
    User
      .joins("LEFT OUTER JOIN assignments ON assignments.user_id = users.id AND assignments.project_id = #{project_id}")
      .where('assignments.id IS NULL')
  end

  def self.unemployed_by_company(company_id)
    User
      .joins("LEFT OUTER JOIN employments ON employments.user_id = users.id AND employments.company_id = #{company_id}")
      .where('employments.id IS NULL')
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def companies_names
    companies.pluck(:name).join(", ")
  end

  def account_status
    self.active? ? "actif" : "inactif"
  end

  def active_for_authentication?
    super && self.active?
  end
end
