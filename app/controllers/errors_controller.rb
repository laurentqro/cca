class ErrorsController < ActionController::Base
  def show
    status_code = request.path[1..-1]
    render action: status_code, status: status_code
  end
end
