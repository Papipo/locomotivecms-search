require 'solid'

require 'locomotive/search/wagon/liquid/tags/search_for'
require 'locomotive/search/wagon/liquid/drops/page'
require 'locomotive/search/wagon/searchable_page'
require 'locomotive/search/wagon/searchable_content_field'
require 'locomotive/search/wagon/searchable_content_entry'

require 'locomotive/mounter/models/base'
require 'locomotive/mounter/models/page'
require 'locomotive/mounter/models/content_field'
require 'locomotive/mounter/models/content_entry'

# encoding: UTF-8
module Locomotive
  module Mounter
    module Models
      class Page < Base
        include Locomotive::Search::SearchablePage
      end

      class ContentField < Base
        include Locomotive::Search::SearchableContentField
      end

      class ContentEntry < Base
        include Locomotive::Search::SearchableContentEntry
      end
    end
  end
end