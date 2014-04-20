require 'locomotive/wagon/liquid/drops/base'
require 'locomotive/wagon/liquid/drops/page'

module Locomotive
  module Wagon
    module Liquid
      module Drops
        class Page < Base

          delegate :searchable, to: :@_source

        end
      end
    end
  end
end