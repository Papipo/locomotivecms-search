module Locomotive
  class SearchService

    def from_backoffice(site, text, options = { radius: 150 })
      # scope the search by the site
      conditions = { 'site_id' => site._id }

      # locale agnostic
      options[:locale] = false

      # launch the search with the current engine
      ::ActiveSearch.search(text, conditions, options).map do |entry|
        # keep only what we really need to display in the suggestions list
        entry.slice('label', 'locale', 'search_type').tap do |_entry|
          _entry['path']         = entry_path(entry)
          _entry['content']      = entry_content(entry)
          _entry['with_locale']  = site.localized?
        end
      end
    end

    protected

    def entry_content(entry)
      content = nil

      # get the first non blank highligthed field
      entry['highlighted'].each do |name, value|
        content = value if content.nil? && value.present?
      end

      content
    end

    def entry_path(entry)
      case entry['original_type']
      when 'Locomotive::Page'
        page_path(entry['original_id'], entry['locale'])
      when /^Locomotive::ContentEntry/
        content_entry_path(entry['content_type_slug'], entry['original_id'], entry['locale'])
      else
        nil
      end
    end

    def page_path(id, locale)
      Locomotive::Engine.routes.url_helpers.edit_page_path(id, locale: locale)
    end

    def content_entry_path(content_type_slug, id, locale)
      Locomotive::Engine.routes.url_helpers.edit_content_entry_path(content_type_slug, id, locale: locale)
    end

  end
end