# encoding: utf-8
module Mongoid #:nodoc:
  module Relations #:nodoc:
    module Referenced #:nodoc:

      class Many < Relations::Many

        def to_indexable(depth = 0)
          criteria.map do |doc|
            doc.to_indexable(depth)
          end
        end

      end
    end
  end
end