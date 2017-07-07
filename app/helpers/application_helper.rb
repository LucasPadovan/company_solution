module ApplicationHelper
  def link_to_add_fields(name, form, folder, association)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(folder + '/' + association.to_s + '/form', form: builder)
    end

    link_to(name, '#', class: 'js-add-fieldset', data: {id: id, fields: fields.gsub("\n", ''), association: association})
  end
end
