Rails.application.routes.draw do

  # The main job of the routes:
  # You map a request to a controller with an action
  get "/hello" => "welcome#index"
  get "/about" => "welcome#about"

  get "/hello/:name" => "welcome#greet", as: :greet

  get "/subscribe" => "subscribe#index", as: :subscribe
  post "/subscribe" => "subscribe#create"

  # get "/questions/new" => "questions#new", as: :new_question
  # post "/questions" => "questions#create", as: :questions
  # get "/questions/:id" => "questions#show", as: :question
  # get "questions/:id/edit" => "questions#edit", as: :edit_question
  # patch "/questions/:id" => "questions#update"
  #
  # delete "questions/:id" => "questions#destroy"

  #The PATH for this URL (index action) is the same as the PATH for the
  # create action (with POST) so we can just use the one we defined
  # for the create which is 'question_path'
  # get "/questions" => "questions#index"

  resources :questions do
    get :search, on: :collection
    patch :mark_done, on: :member
    post :approve

    # nested resources
    #By defining 'resources :answers' nested inside 'resources
    # :questions' Rails will define all the answers routes prepended
    # with '/questions/:question_id'. This enables us to have the
    # question_id handy so we can create the answer associated with
    # a question with 'question_id'

    resources :answers, only: [:create, :destroy, :update]

  end

# we do this to avoid triple nesting comments under 'resources :answers'
# within the 'resources :questions' as it will be very cumbersome to
# generate routes and use forms. We don't need another set of `answers`
# routes in here so pass the `only: []` option to it.
  resources :answers, only: [] do
    resources :comments, only: [:create, :destroy]
  end

  resources :users, only: [:create, :new]


  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end




  # post "/questions/:question_id/answer" => "answers#create"


  # setting homepage of our applicationt to be the questions
  # listings page
  root "questions#index"


  # THis maps any GET request with path "/hello" to WelcomeController
  # and index action within that controller




  # Every user request in Rails must be handled by a controller
  # and action

  # 'get' is a method from Rails toes to help us respond to GET
  #  REQUEST.
  # It takes a hash as a parameter get({"/hello" => "welcome#index"})


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
