module Locomotive
  class SearchController < ::Locomotive::BaseController

    skip_load_and_authorize_resource

    respond_to :json

    def index
      results = self.search_service.from_backoffice(current_site, params[:query])
      respond_with(results: results)
    end

    protected

    def search_service
      @search_service ||= Locomotive::SearchService.new
    end

  end
end