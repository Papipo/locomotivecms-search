module Locomotive
  module Liquid
    module Tags

      class SearchFor < Solid::Block

        # register the tag
        tag_name :search_for

        def display(text, options = {}, &block)
          site_id = current_context.registers[:site]._id

          current_context.stack do
            current_context['search'] = search(site_id, text, options)

            yield
          end
        end

        protected

        def search(site_id, text, options = {})
          search_options  = { radius: 150 }.merge(options)
          conditions      = { 'site_id' => site_id }

          begin
            ::ActiveSearch.search(text, conditions, search_options)
          rescue Exception => exception
            {
              'error'   => true,
              'message' => exception.message
            }
          end
        end

      end

    end
  end
end
