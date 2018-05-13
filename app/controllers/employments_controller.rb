class EmploymentsController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
  end

  def create
    @employment = Employment.new(employment_params)

    respond_to do |format|
      if @employment.save
        format.js
      end
    end
  end

  def destroy
    Employment.find(params[:id]).destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def employment_params
    params.require(:employment).permit(:company_id, :user_id)
  end
end
