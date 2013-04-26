class Locomotive::Search::ContentTypeReindexer
  def perform(content_type_id)
    Locomotive::ContentType.find(content_type_id).reindex
  end
end