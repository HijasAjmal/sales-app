Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  	namespace :api do
	  namespace :v1 do
	    resources :users do
	        collection do
	          post :login, :action => :login
	          post :create_new_user, :action => :create_new_user
	          get :list_users, :action => :list_users
	          post :show_user_profile, :action => :show_user_profile
	          post :edit_user, :action => :edit_user
	        end
	    end

	    resources :purchase_stores do
	        collection do
	         	get :list_stores, :action => :list_stores 
	        end
	    end

	    resources :stores do
	        collection do
	         	get :list_stores, :action => :list_stores
	         	post :fetch_store_balance_amount, :action => :fetch_store_balance_amount
	        end
	    end

	    resources :purchases do
	        collection do
	        	post :list_purchases, :action => :list_purchases  
	        end
	    end
	    resources :sales do
	        collection do
	         	post :list_sales, :action => :list_sales
	        end
	    end
	    resources :weekend_amount_records do
	        collection do
	         	get :list_records, :action => :list_records
	         	post :update_weekend_records, :action => :update_weekend_records
	        end
	    end
	    resources :finance_transactions do
	        collection do
	        	post :list_transactions, :action => :list_transactions
	        end
	    end
	    resources :dashboards do
	        
	    end
	  end
	end
end


