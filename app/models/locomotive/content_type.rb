require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'content_type').to_s

Locomotive::ContentType.class_eval do
  def reindex
    entries.where(:updated_at.lt => self.updated_at).each { |entry| entry.update_attribute(:updated_at, Time.now) }
  end
end