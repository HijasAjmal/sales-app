Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  	namespace :api do
	  namespace :v1 do
	    resources :users do
	        collection do
	          post :login, :action => :login
	        end
	        # member do
	        #
	        # end
	     end
	  end
	end
end
