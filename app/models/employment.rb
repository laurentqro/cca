class Employment < ApplicationRecord
  belongs_to :company
  belongs_to :user

  validate :user_not_yet_employed_by_company

  def user_not_yet_employed_by_company
    if employment_exists?
      errors[:base] << 'Utilisateur déjà présent dans ce groupe'
    end
  end

  private

  def employment_exists?
    Employment.exists?(company_id: company_id, user_id: user_id)
  end
end
