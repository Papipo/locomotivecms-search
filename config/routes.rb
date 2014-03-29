Rails.application.routes.draw do

  namespace :locomotive do

    get 'search' => 'search#index', as: :search

  end

end
