class API::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  private
  
    def render_404(exception = nil)
      respond_to do |format|
        format.json { render json: { status: 404, error: (exception ? exception.message : 'not_found') }, status: :not_found }
        format.html { render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html' }
      end
    end
end
