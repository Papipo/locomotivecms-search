require "custom_fields"

CustomFields::Field.class_eval do
  field :searchable, type: Boolean, default: false
end