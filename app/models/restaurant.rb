class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
end
