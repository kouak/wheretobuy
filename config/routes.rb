ActionController::Routing::Routes.draw do |map|

  map.resources :brand_types

  map.resources :stores
  
  map.resources :cities, :only => [:autocomplete], :collection => {:autocomplete => :get}

  map.resources :countries, :only => [:index, :show] do |country|
    country.resources :cities
  end
  
  map.resources :comments, :except => [:index, :create, :new]

  map.resources :brands, :collection => {:search => :get} do |brand|
    brand.resources :comments, :only => [:new, :create]
    brand.resource :brand_wiki, :except => [:index, :new, :create], :member => {:history => :get, :diff => :get}
    brand.fans '/fans', :controller => :brands, :action => :fans
    brand.tags '/tags', :controller => :brands, :action => :tags
    brand.activity '/activity', :controller => :brands, :action => :activity
    brand.resources :taggings, :only => [:new, :create]
    brand.comments '/comments', :controller => :brands, :action => :comments
    brand.resources :votes, :only => [:index], :collection => {:vote_for => :post, :vote_against => :post, :vote_nil => :post}
  end

  # The priority is based upon order of creation: first created -> highest priority.


  map.search '/search', :controller => 'search', :action => :index
  
  
  
  map.resources :user_sessions, :only => [:create]
  map.login '/login', :controller => 'user_sessions', :action => :new, :method => :get
  map.logout '/logout', :controller => 'user_sessions', :action => :destroy, :method => :delete
  
  map.resource :account, :except => :index, :controller => :account, :member => [:edit_email, :edit_password, :edit_profile, :friends]
  
  map.resources :users, :only => [:index, :show] do |user|
    user.favorite_brands '/favorite_brands', :controller => :users, :action => :favorite_brands
    user.resources :comments, :only => [:new, :create]
    user.comments '/comments', :controller => :users, :action => :comments
    user.activity '/activity', :controller => :users, :action => :activity
    user.resources :friendships, :only => [:create, :destroy], :member => {:approve => :put}
    user.friends '/friends', :controller => :users, :action => :friends
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