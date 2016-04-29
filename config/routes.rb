Rails.application.routes.draw do

  root to: redirect('/articles')

  resources :cards, only: [:index, :show] do
    resources :reviews, only: [:create, :destroy]
  end

  resources :articles, except: :create do
    resources :cards, only: [:index]
    member do
      post 'restore'
      post 'update_cards'
      patch 'autosave', action: :update_autosave
      match via: [:patch, :put],
        constraints: lambda { |req| req.params.key?(:autosave) },
        action: :update_autosave
    end
  end

end
