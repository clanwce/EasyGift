EasyGift::Application.routes.draw do
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # match '/users/sign_in' => 'home#index'
  root :to => 'home#profile'
  match 'testpage' => 'home#test'
  match 'landing' => 'home#index'
  match 'account_settings' => 'home#account_settings'
  match 'profile'   => 'home#profile'

  match 'likes/create' => 'likes#create', :via => [:post]
  match 'comments/final' => 'comments#final', :via => [:post]
  match '/user_notifications/create' => 'user_notifications#create'


  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'user_sessions' }

  # resources :authentications
  match 'users' => 'users#index'
  match 'users/:id' => 'users#show'
  match 'users/edit_password' => 'users#edit_password'
  match 'auth/:provider/callback' => 'authentications#create'
  match 'users/update_password' => 'users#update_password'
  match 'users/generate_new_password_email' => 'users#generate_new_password_email'
  post 'comments' => 'comments#create'
  match 'feed' => 'home#feed'
  match 'gift_requests/searchresult' => 'gift_requests#gift_request_search', :via => [:post]
  match 'tags/tag_search' => 'tags#tag_search', :via => [:post]
  match 'comments/:id/:status' => 'comments#likes'
  match 'follow' => 'users#follow', :via => [:post]
  match '/unfollow/:id' => 'users#unfollow', :via => [:post]
  match '/privacy_policy' => 'home#privacy_policy'
  # match '/helloworld' => 'home#hello_world'
  #get 'gift_requests/searchresult' => 'gift_requests#tag_search'

  # gift request  match 'gift_requests/:id' => 'comments#create', :via => [:post]


  resources :gift_requests do
    get :autocomplete_gift_request_title, :on => :collection
    get :autocomplete_tag_name, :on => :collection
  end

  resources :tags, only: [:index, :create, :show]

  post '/gift_requests/autocomplete_tag_name'
  post '/tags/create'
  post '/user_notifications/batch_read' => 'user_notifications#batch_read'

  resources :users, only: [:index, :show]
  # match 'gift_requests/autocomplete_gift_request_title'

  # The priority is based upon order of creation:
  # first created -> highest priority.



  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"
end
