Locomotive::Liquid::Drops::Site.class_eval do
  def search
    text        = @context.registers[:controller].params[:search]
    conditions  = { 'site_id' => @_source.id }

    @search ||= ::ActiveSearch.search(text, conditions, radius: 150)
  end
end
