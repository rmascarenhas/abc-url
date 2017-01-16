root to: "home#index"

get "/url/:id", to: "url#show"
get "/:code", to: "url#resolve"
