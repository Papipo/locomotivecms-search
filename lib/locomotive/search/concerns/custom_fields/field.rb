CustomFields::Field.class_eval do
  field :searchable, type: Boolean, default: false
end

# Next lines might belong to their own file, but since they are extremely related to the above one, I'll leave them here.
Locomotive::ContentFieldPresenter.class_eval do
  properties :searchable, type: 'Boolean'
end

Locomotive::PartialsCell.add_template(:custom_fields_form, "searchable")