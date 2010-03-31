ActionController::Routing::Routes.draw do |map|
  map.resources :friendships


  map.resources :brand_types

  map.resources :stores
  
  map.resources :cities, :only => [:autocomplete], :collection => {:autocomplete => :get}

  map.resources :countries, :only => [:index, :show] do |country|
    country.resources :cities
  end

  map.resources :brands, :collection => {:search => :get} do |brand|
    brand.resources :comments, :except => [:index]
    brand.resource :brand_wiki, :except => [:index, :new, :create], :member => {:history => :get, :diff => :get}
    brand.fans '/fans', :controller => :brands, :action => :fans
    brand.comments '/comments', :controller => :brands, :action => :comments
    brand.resources :votes, :only => [:index], :collection => {:vote_for => :post, :vote_against => :post, :vote_nil => :post}
  end

  # The priority is based upon order of creation: first created -> highest priority.


  map.search '/search', :controller => 'search', :action => :index
  map.login '/login', :controller => 'user_sessions', :action => :new
  map.create_login '/login', :controller => 'user_sessions', :action => :create, :method => :post
  map.logout '/logout', :controller => 'user_sessions', :action => :destroy
  
  map.resource :user_session
  
  map.resource :account, :only => [:edit, :update, :delete, :destroy], :controller => :users do |account|
    map.account '/account', :controller => 'users', :action => 'account', :conditions => { :method => :get }
  end
  
  map.resources :users, :only => [:index, :show, :new, :create] do |user|
    user.friends '/friends', :controller => :users, :action => :friends
    user.favorite_brands '/favorite_brands', :controller => :users, :action => :favorite_brands
    user.resources :comments, :except => [:index]
    user.comments '/comments', :controller => :users, :action => :comments
  end
  
  map.activate '/activate/:activation_code', :controller => 'activations', :action => 'activate'
  
  map.resource :activation, :only => [:new, :create]
  
  map.resource :password_resets, :only => [:new, :create, :update, :edit]
  
  map.root :controller => :static_pages, :action => :home
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end