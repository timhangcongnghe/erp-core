module Erp
	module Frontend
		class UsersController < ApplicationController
			def omniauth_login
				auth = request.env["omniauth.auth"]
				user = Erp::User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Erp::User.create_with_omniauth(auth)
				user = Erp::User.find(user.id)
				sign_in(:user, user)
				redirect_to erp_online_store.root_url, :notice => "Bạn đã đăng nhập thành công!"
			end
		end
	end
end