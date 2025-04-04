class Brand < ApplicationRecord
  has_many :models, dependent: :destroy

  validates :name,uniqueness: { case_sensitive: false, message: "ya está registrado. Las marcas son únicas sin importar mayúsculas o minúsculas." }
  validates :name, presence: { message: "no puede estar vacío" }
  validates :name, length: { minimum: 3, message: "debe tener al menos 3 caracteres" }
  
  def average_price
    models.any? ? models.average(:average_price).to_i : 0
  end
  
  private

end
