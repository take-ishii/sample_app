class API::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  private
  
    def render_404(exception = nil)
      render json: { status: 404, error: (exception ? exception.message : 'not_found') }, status: :not_found
    end
end
