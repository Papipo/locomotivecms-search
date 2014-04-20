module Locomotive
  module Liquid
    module Tags

      class SearchFor < ::Solid::Block

        # register the tag
        tag_name :search_for

        def display(text, options = {}, &block)
          current_context.stack do
            current_context['search'] = search(text, options)

            yield
          end
        end

        protected

        def mounting_point
          current_context.registers[:mounting_point]
        end

        def search_for_pages(text)
          pages = mounting_point.pages.values

          pages.select { |page| page.searchable && page.title[text] }.map do |page|
            {
              'title'       => page.title,
              'fullpath'    => page.safe_fullpath,
              'locale'      => I18n.locale,
              'highlighted' => {
                'searchable_content' => "<em>#{page.title}</em>"
              }
            }
          end
        end

        def search_for_content_entries(text)
          entries = mounting_point.content_entries.values

          entries.select { |entry| entry.searchable? && entry._label[text] }.map do |entry|
            {
              'label'             => entry._label,
              '_slug'             => entry._slug,
              'content_type_slug' => entry.content_type.slug,
              'locale'            => I18n.locale,
              'highlighted'       => {
                entry.content_type.label_field => "<em>#{entry._label}</em>"
              }
            }
          end
        end

        def search(text, options = {})
          results = text.blank? ? [] : [search_for_pages(text), search_for_content_entries(text)].flatten.compact

          # TODO: perform a real search
          {
            'results'       => results.shuffle,
            'total_entries' => results.size,
            'total_pages'   => 1,
            'page'          => 0,
            'per_page'      => 10
          }
        end

      end

    end
  end
end
