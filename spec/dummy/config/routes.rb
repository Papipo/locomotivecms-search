Dummy::Application.routes.draw do
  
  mount Locomotive::Engine => '/locomotive', :as => 'locomotive' # you can change the value of the path, by default set to "/locomotive"
      

  mount Locomotive::Engine => '/locomotive', as: 'locomotive'
end
