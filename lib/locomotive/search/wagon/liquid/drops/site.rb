Locomotive::Liquid::Drops::Site.class_eval do
  def search
    text        = @context.registers[:request].params[:search]

    @search ||= ::ActiveSearch.search(text, conditions, radius: 150)
  end
end
