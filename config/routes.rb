Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'weekend_amount_records/index'
      get 'weekend_amount_records/create'
      get 'weekend_amount_records/update'
      get 'weekend_amount_records/destroy'
      get 'weekend_amount_records/list_records'
    end
  end
  get 'purchases/index'
  get 'purchases/create'
  get 'purchases/create'
  get 'purchases/update'
  get 'purchases/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  	namespace :api do
	  namespace :v1 do
	    resources :users do
	        collection do
	          post :login, :action => :login
	          post :create_new_user, :action => :create_new_user
	          get :list_users, :action => :list_users
	          post :show_user_profile, :action => :show_user_profile
	        end
	        # member do
	        #
	        # end
	    end

	    resources :purchase_stores do
	        collection do
	         	get :list_stores, :action => :list_stores 
	        end
	        # member do
	        #
	        # end
	    end

	    resources :stores do
	        collection do
	         	get :list_stores, :action => :list_stores
	         	post :fetch_store_balance_amount, :action => :fetch_store_balance_amount
	        end
	        # member do
	        #
	        # end
	    end

	    resources :purchases do
	        collection do
	        	post :list_purchases, :action => :list_purchases  
	        end
	        # member do
	        #
	        # end
	    end
	    resources :sales do
	        collection do
	         	post :list_sales, :action => :list_sales
	        end
	        # member do
	        #
	        # end
	    end
	    resources :weekend_amount_records do
	        collection do
	         	get :list_records, :action => :list_records
	         	post :update_weekend_records, :action => :update_weekend_records
	        end
	        # member do
	        #
	        # end
	    end
	  end
	end
end


