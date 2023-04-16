Rails.application.routes.draw do
  root "uploads#index"

  resources :uploads, only: [:create, :update] do
    resources :payments, only: [:index]

    get "/reports/payor_totals", to: "reports#payor_totals", constraints: { format: 'csv' }
    get "/reports/branch_totals", to: "reports#branch_totals", constraints: { format: 'csv' }
  end
end
