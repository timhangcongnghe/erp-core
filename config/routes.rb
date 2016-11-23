Erp::Core::Engine.routes.draw do
  devise_for :users, class_name: "Erp::User", module: :devise, :controllers => {
		:sessions => "erp/users/sessions"
	}
	namespace :backend do
		get '/' => 'backend#index'
		get '/dashboard' => 'dashboard#index', as: :dashboard
	end
end
