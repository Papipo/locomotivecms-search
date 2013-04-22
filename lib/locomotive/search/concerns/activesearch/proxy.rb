require "activesearch/proxy"

ActiveSearch::Proxy.class_eval do
  alias_method :to_liquid, :to_a
end