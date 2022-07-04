class ApplicationController < ActionController::Base
  unless Rails.env.development?
    rescue_from Exception,                        with: :render_server_error
    rescue_from ActiveRecord::RecordNotFound,     with: :render_client_error
    rescue_from ActionController::RoutingError,   with: :render_client_error
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def render_client_error(error = nil)
    logger.info "Rendering 404 with exception: #{error.message}" if error

    if request.format.to_sym == :json
      render json: { error: '404 error' }, status: :not_found
    else
      render 'errors/error_404', status: :not_found
    end
  end

  def render_server_error(error = nil)
    logger.error "Rendering 500 with exception: #{error.message}" if error
    Airbrake.notify(error) if error # Airbrake/Errbitを使う場合はこちら

    if request.format.to_sym == :json
      render json: { error: '500 error' }, status: :internal_server_error
    else
      render 'errors/error_500', status: :internal_server_error
    end
  end
end
