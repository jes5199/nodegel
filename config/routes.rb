Rails.application.routes.draw do
  get 'invite/index'

  get 'invite/request'

  get '/ /invite', to: 'invite#index'
  post '/ /invite', to: 'invite#activate'
  post '/ /invite/consume', to: 'invite#claim'
  get '/ /invite/consume', to: 'invite#claim'

  get '/ /sign up', to: 'invite#wish'

  get '/ /log in', to: 'user#login'
  post '/ /log in', to: 'user#login'

  get '/ /log out', to: 'user#logout'
  post '/ /log out', to: 'user#logout'

  get '/ /go', to: 'node#go'
  post '/ /go', to: 'node#go'
  get '/ /quick', to: 'node#quick'
  post '/ /annotate', to: 'node#annotate'
  post '/ /unannotate', to: 'node#unannotate'
  get ':namespace/:name/:author', to: 'node#zoom', :constraints => {:namespace => /[^\/]+/, :name => /[^\/]+/, :author => /[^\/]+/}
  get ':namespace/:name', to: 'node#node', :constraints => {:namespace => /[^\/]+/, :name => /[^\/]+/}
  post ':namespace/:name', to: 'node#node', :constraints => {:namespace => /[^\/]+/, :name => /[^\/]+/}

  get ':namespace', to: 'namespace#namespace', :constraints => {:namespace => /[^\/]+/}

  get '/' => redirect("/%20/log%20in")

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
