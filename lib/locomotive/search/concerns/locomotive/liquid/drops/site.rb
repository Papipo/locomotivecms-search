Locomotive::Liquid::Drops::Site.class_eval do
  def search
    @search ||= ::ActiveSearch.search(@context.registers[:controller].params[:search]).where('_stored.site_id' => _source.id)
  end
end
