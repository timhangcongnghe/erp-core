require_dependency "erp/application_controller"

module Erp::Frontend
  class FrontendController < Erp::ApplicationController
    layout 'erp/frontend/index'
  end
end