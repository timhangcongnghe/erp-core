Erp::Core::Engine.routes.draw do
  devise_for :users, class_name: "Erp::User", module: :devise, :controllers => {
		:sessions => "erp/users/sessions"
	}
  root to: "home#index"
	namespace :backend do
		get '/' => 'dashboard#index'
	end
end
