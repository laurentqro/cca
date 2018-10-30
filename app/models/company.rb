class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true

  def self.default_scope
    order('name ASC')
  end
end
