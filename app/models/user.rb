class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :invitable

  belongs_to :company

  has_many :documents
  has_many :folders

  has_many :subscriptions, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :employments, dependent: :destroy
  has_many :activities,  dependent: :destroy

  has_many :projects,  through: :assignments

  accepts_nested_attributes_for :employments, reject_if: lambda { |e| e[:company_id].blank? }, allow_destroy: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  validates :first_name, :last_name, :city, presence: true

  enum group: [ :partner, :employee, :admin ]

  def self.default_scope
    order('last_name ASC')
  end

  scope :search, ->(query) {
    if query.present?
      includes(:projects, :company)
        .where("unaccent(first_name) ILIKE unaccent(?) OR unaccent(last_name) ILIKE unaccent(?)", "%#{query}%", "%#{query}%")
    end
  }

  scope :assigned_to_project, ->(query) {
    if query.present?
      joins(:projects)
        .where("unaccent(projects.name) ILIKE unaccent(?)", "%#{query}%")
    end
  }

  scope :employed_by_company, ->(query) {
    if query.present?
      joins(:company)
        .where("unaccent(companies.name) ILIKE unaccent(?)", "%#{query}%")
    end
  }

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
    "#{last_name}, #{first_name}"
  end

  def projects_names
    projects.pluck(:name).join(", ")
  end

  def account_status
    self.active? ? "actif" : "inactif"
  end

  def active_for_authentication?
    super && self.active?
  end

  def invitation_status
    return "acceptée" if has_accepted_invitation?
    return "envoyée"  if invited?
    "aucune"
  end

  def has_accepted_invitation?
    invitation_accepted_at.present?
  end

  def invited?
    invitation_sent_at.present?
  end
end
