require "activesearch/proxy"

ActiveSearch::Proxy.class_eval do

  def to_liquid
    {
      'results'       => self.to_a,
      'total_entries' => self.total_entries,
      'total_pages'   => self.total_pages,
      'page'          => self.page,
      'per_page'      => self.per_page
    }
  end

end