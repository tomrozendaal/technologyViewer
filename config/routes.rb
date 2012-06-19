TechnologyViewer::Application.routes.draw do

  match 'programmingLanguages' => 'page#programmingLanguages', :path => 'programming-languages', :sub => 'best-rated'
  match 'programmingLanguages/technology/:tech' => 'page#technology', :path => 'programming-languages/technology/:tech'
  match 'programmingLanguages/*sub' => 'page#programmingLanguages', :path => 'programming-languages/*sub'


  match 'webFrameworks' => 'page#webFrameworks', :path => 'web-frameworks', :sub => 'best-rated'
  match 'webFrameworks/:tech' => 'page#technology', :path => 'web-frameworks/technology/:tech'
  match 'webFrameworks/*sub' => 'page#webFrameworks', :path => 'web-frameworks/*sub'

  match 'contentManagementSystems' => 'page#contentManagementSystems', :path => 'content-management-systems', :sub => 'best-rated'
  match 'contentManagementSystems/:tech' => 'page#technology', :path => 'content-management-systems/technology/:tech'
  match 'contentManagementSystems/*sub' => 'page#contentManagementSystems', :path => 'content-management-systems/*sub'

  match 'about' => 'page#about'
  match 'help' => 'page#help'
  match 'help/*sub' => 'page#help'
  match 'search' => 'page#search'

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
  resources :page
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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'page#overview'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
