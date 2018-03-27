class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :documents, dependent: :destroy

  validates :name, presence: true
  validate :name_is_unique_inside_parent_folder

  has_ancestry

  def has_content?
    documents.exists? || children.exists?
  end

  def name_is_unique_inside_parent_folder
    if siblings.pluck(:name).include?(name)
      errors.add(:name, "indisponible. Merci d'en choisir un autre.")
    end
  end

  def contains_only_resources_owned_by_user?(user)
    subtree.all? do |folder|
       folder.owned_by_user?(user) &&
       folder.documents.all? { |document| document.owned_by_user?(user) }
    end
  end

  def owned_by_user?(user)
    user_id == user.id
  end
end
