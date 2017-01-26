class PackageProportionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value < [record.width, record.height, record.depth].max * 0.1
      record.errors.add(attribute, "cannot be so short as to make the package oddly sized :(")
    end
  end
end