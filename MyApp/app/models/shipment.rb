class Shipment < ActiveRecord::Base
  # Basic validations - ignore for this example
  validates_presence_of :weight, :height, :depth, :width
  validates_numericality_of :weight, :height, :depth, :width

  # Custom validations
  validate :volume_is_within_bounds
  validates_with DensityValidator
  validates :height, :width, :depth, package_proportion: true

  def volume
    height * width * depth
  end

  def density
    weight / volume
  end

  private

  def volume_is_within_bounds
    if volume > 4000
      errors.add(:volume, "cannot be above 400 cubic inches")
    elsif volume < 20
      errors.add(:volume, "cannot be below 20 cubic inches")
    end
  end
end
