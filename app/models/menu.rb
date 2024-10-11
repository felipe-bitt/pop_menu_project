class Menu < ApplicationRecord
  has_and_belongs_to_many :menu_items
  belongs_to :restaurant

  validates :name, presence: true
end
