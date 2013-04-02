class ActiveSearch::Mongoid::Model
  def to_liquid
    _stored.each_with_object({}) do |(k,v),memo|
      memo[k] = v.respond_to?(:has_key?) && v.has_key?(I18n.locale.to_s) ? v[I18n.locale.to_s] : v
    end
  end
end