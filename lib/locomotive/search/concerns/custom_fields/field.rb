CustomFields::Field.class_eval do
  field :searchable, type: Boolean, default: false
end

module CustomFields
  module Types
    module Select
      class Option

        def to_indexable(depth = 0)
          self.name
        end

      end
    end
  end
end