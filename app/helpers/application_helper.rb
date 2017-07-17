module ApplicationHelper
  def link_to_add_fields(name, form, folder, association)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render association_folder_path(folder, association), form: builder
    end

    link_to(name, '#', class: 'btn btn-primary btn-sm js-add-fieldset', data: {id: id, fields: fields.gsub("\n", ''), association: association})
  end

  def association_folder_path(folder, association)
    "#{folder}/#{association.to_s}/form"
  end
end
