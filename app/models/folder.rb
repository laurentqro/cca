class Folder < ApplicationRecord
  belongs_to :project
  has_many :documents

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
end
