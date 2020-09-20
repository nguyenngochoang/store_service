Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products
  resources :transactions, only: [] do
    collection do
      get :client_token
      post :checkout
    end
  end
end
