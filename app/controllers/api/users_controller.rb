class Api::UsersController < Api::ApiController
  def index
    if filters?
      users = User.assigned_to_project(params[:project])
                  .employed_by_company(params[:company])
                  .search(params[:filter])

    else
      users = User.includes(:projects, :company)
    end

    render json: users
  end

  def filters?
    params[:project].present? || params[:company].present? || params[:filter].present?
  end
end
