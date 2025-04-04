class Model < ApplicationRecord
  belongs_to :brand

  scope :greater_than_price, ->(price) { where("average_price > ?", price) }
  scope :less_than_price, ->(price) { where("average_price < ?", price) }

  validates :name, uniqueness: { scope: :brand_id, case_sensitive: false, message: "ya está registrado dentro de esta marca." }

  validates :name, presence: { message: "no puede estar vacío" }
  validates :name, length: { minimum: 1, message: "debe tener al menos 1 caracter" }

  validates :average_price, presence: { message: "no puede estar vacío" }, on: :update
  validates :average_price, numericality: { only_integer: true, message: "Debe ser un número entero" }, if: :average_price?
  validates :average_price, numericality: { greater_than: 100_000, message: "Debe ser mayor a 100,000" }, if: :average_price? ,on: :update
  
  validate :validate_average_price_on_create, on: :create

  def average_price?
    !average_price.nil? && average_price != ""
  end

  def validate_average_price_on_create
    if average_price == "" || average_price.blank?
      errors.add(:average_price, "No debe esta vacio")
      return 
    end

    if average_price.nil?
      self.average_price = 0
      return
    end
  
    if average_price.is_a?(String)
      unless average_price.match?(/\A\d+\z/)
        errors.add(:average_price, "Debe ser un número entero válido.")
        return
      end
      average_price_int = average_price.to_i
    elsif average_price.is_a?(Integer)
      average_price_int = average_price
    else
      errors.add(:average_price, "Debe ser un número entero.")
      return
    end
  
    if average_price_int != 0 && average_price_int < 100_000
      errors.add(:average_price, "Debe ser mayor a 100,000")
    end
  
    self.average_price = average_price_int
  end
end
