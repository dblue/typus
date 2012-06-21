module Admin::Resources::DataTypes::CarrierwaveHelper

  def table_carrierwave_field(attribute, item)
    options = { :width => 25 }
    typus_carrierwave_preview(item, attribute, options)
  end

  def link_to_detach_attribute_for_carrierwave(attribute)
    validators = @item.class.validators.delete_if { |i| i.class != ActiveModel::Validations::PresenceValidator }.map(&:attributes).flatten.map(&:to_s)
    attachment = @item.send(attribute)
    
    if attachment.present? && !validators.include?(attribute) && attachment
      attribute_i18n = @item.class.human_attribute_name(attribute)
      param_key = "#{ActiveModel::Naming.param_key(@item)}[remove_#{attribute}]"
      link_options = {:action => 'update', :id => @item.id, param_key => true, :_continue => true}
      label_text = <<-HTML
#{attribute_i18n}
<small>#{link_to Typus::I18n.t("Remove"), link_options, :confirm => Typus::I18n.t("Are you sure?")}</small>
      HTML
      label_text.html_safe
    end
  end

  def typus_carrierwave_preview(item, attachment, options = {})
    data = item.send(attachment)
    if (data.file)
      versions = data.versions.keys
      if versions.include?(Typus.file_preview) && versions.include?(Typus.file_thumbnail)
        render "admin/templates/carrierwave_preview",
               :attachment => data,
               :preview => data.send(Typus.file_preview).url,
               :thumb => data.send(Typus.file_thumbnail).url,
               :options => options
      else
        link_to data.identifier, data.url
        # params[:_popup] ? data.name : link_to(data.identifier, data.url)
      end
    end
  end
  
  def typus_carrierwave_form_preview(item, attachment, options = {})
    data = item.send(attachment)
    return unless data.file

    versions = data.versions.keys
    if versions.include?(Typus.file_preview) && versions.include?(Typus.file_thumbnail)
      render "admin/templates/carrierwave_preview",
             :attachment => data,
             :preview => data.send(Typus.file_preview).url,
             :thumb => data.send(Typus.file_thumbnail).url,
             :options => options
    else
      html = params[:_popup] ? data.identifier : link_to(data.identifier, data.url)
      # OPTIMIZE: Generate the tag with Ruby.
      "<p>#{html}</p>".html_safe
    end
  end
  
end