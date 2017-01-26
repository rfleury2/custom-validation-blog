Rails provides a variety of helpers for quickly performing commonly used validations - presence, numericality, uniqueness, etc.  When it comes to performing custom validations, we have a few options.  For the obligatory contrived example, we have a shipments table when each record has a ```:width```, ```:height```, ```:depth```, and ```:weight```.  Each shipment must adhere to the following rules:
* The volume of the shipment must be between 20 and 4000 cubic centimeters (volume validation)
* The density of the shipment cannot exceed 200 grams per cubic centimeter (density validation)
* No one side's length can be less than 10% of the largest side (proportion validation)

In order to make the validations more readable, we have the following methods added to the shipment class:

```ruby
class Shipment < ActiveRecord::Base
  ...
  def volume
    height * width * depth
  end

  def density
    weight / volume
  end
  ...
end
```

Let's use a different implementation strategy for each of the validations.  First, let's validate the shipment's volume through a custom method.  We can use the ```validate``` method to point the validation to our custom method, implemented in the private interface:

```ruby
class Shipment < ActiveRecord::Base
  ...
  validate :volume_is_within_bounds
  ...

  private

  def volume_is_within_bounds
    if volume > 4000
      errors.add(:volume, "cannot be above 400 cubic inches")
    elsif volume < 20
      errors.add(:volume, "cannot be below 20 cubic inches")
    end
  end
end
```

Building a custom validation on a private method within the model is the quickest and easiest way to write a custom validation.  Since the validation method is a part of the shipment object's interface, ```self``` is the instance of ```Shipment``` we are validating.  As such, we can call ```#volume``` within our private validation method to determine whether we should add a validation error.  This works fine for a quick validation, but as we add more conditions, having a method within the model can quickly bloat it with too much validation logic.  Luckily, we can use ```ActiveModel::Validator``` to build a custom validator class to contain that logic.  Let's do that for validating the density.

We can declare a custom validation class for the shipment record by using the ```validates_with``` method:
```ruby
class Shipment < ActiveRecord::Base
  ...
  validates_with DensityValidator
  ...
end
```

Then, in the /models/concerns directory, we create a file named ```density_validator.rb```.  The DensityValidator inherits from ActiveModel::Validator, which expects there to be a method called #validate, where we can access the record, put it through the validation logic, and assign any validation errors to the record:

```ruby
class DensityValidator < ActiveModel::Validator
  def validate(record)
    if record.density > 20
      record.errors.add(:density, "is too high to safely ship")
    end
  end
end
```

I prefer creating a whole new validator class to using a method in the shipments class.  All of the logic is contained in a different class, which keeps the model lean, but does not sacrifice readibility.  The validates_with ClassName makes it obvious for the reader where the object is being validated and the #validate(record) expectation makes the validator class intuitive as well.

So far so good, but all that we have validated so far has happened at the whole object level.  Validating density and volume require access to the entire object.  What if we need to custom validate at the attribute level?




* Validate through a custom method
* Validate through a custom record validator
* Validate through a custom attribute validator
