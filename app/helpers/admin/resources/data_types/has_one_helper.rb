module Admin::Resources::DataTypes::HasOneHelper

  def typus_form_has_one(field)
    setup_relationship(field)

    related_items = @item.send(field)
    @items =  related_items ? [related_items] : []

    # TODO: Find a cleaner way to add these actions ...
    @resource_actions = [["Edit", {:action=>"edit"}, {}],
                         ["Trash", { :resource_id => @item.id, :resource => @resource.model_name, :action => "destroy" }, { :confirm => "Trash?" }]]

    locals = { :association_name => @association_name, :table => build_relationship_table, :add_new => nil }

    if @items.empty?
      options = { :resource_id => nil, @reflection.foreign_key => @item.id }
      locals[:add_new] = build_add_new_for_has_one(@model_to_relate, field, options)
    end

    render "admin/templates/has_one", locals
  end

  def build_add_new_for_has_one(klass, field, options = {})
    if admin_user.can?("create", klass)
      default_options = { :controller => "/admin/#{klass.to_resource}",
                          :action => "new",
                          :layout => "admin/headless" }

      link_to Typus::I18n.t("Add New"), default_options.merge(options), { :class => "iframe" }
    end
  end

end
