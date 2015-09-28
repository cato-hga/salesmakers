class BaseApplicationController < ActionController::Base
  include Pundit

  before_action :additional_exception_data,
                :set_staging
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Exception do |ex|
    ActiveSupport::Notifications.instrument "exception.action_controller", message: ex.message, inspect: ex.inspect, backtrace: ex.backtrace
    if ex.is_a?(Pundit::NotAuthorizedError)
      permission_denied
    elsif !Rails.env.test?
      raise ex
    end
  end

  protected

  def additional_exception_data
    request.env["exception_notifier.exception_data"] = {
        current_person: @current_person,
        candidate: @candidate
    }
  end

  def date_time_string
    Time.zone.now.strftime('%Y-%m-%d_%H-%M')
  end

  private

  def set_staging
    @staging = Rails.env == 'staging'
  end

  def permission_denied
    render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false
  end
end
