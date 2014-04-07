Xtable::Application.routes.draw do
  resources :groups do
    collection do
      get 'search'
    end
    get 'subscribe'
    get 'unsubscribe'
  end

  resources :events

  root to: "staticcontent#home"
  
  get "/private" => "staticcontent#private_content", as: "private_content" 
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }, skip: [:registrations, :sessions]
  
  
  as :user do    
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    delete 'users' => 'devise/registrations#destroy', :as => 'delete_user_registration'
    get 'users/sign_in' => 'devise/sessions#new', :as => 'new_user_session'
    delete 'users/sign_out' => 'devise/sessions#destroy', :as => 'destroy_user_session'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
