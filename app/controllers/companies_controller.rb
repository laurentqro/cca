class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    @company = current_resource
  end

  def new
    @company = Company.new
  end

  def create
    company = Company.new(company_params)

    if company.save
      flash[:notice] = 'Groupe créé avec succès.'
      flash[:class] = 'success'
      redirect_to company
    else
      render :new
    end
  end

  def edit
    @company = current_resource
  end

  def update
    company = current_resource

    if company.update(company_params)
      flash[:notice] = 'Modifications enregistrées.'
      flash[:class] = 'success'
      redirect_to company
    else
      render :edit
    end
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end

  def current_resource
    @current_resource ||= Company.find(params[:id]) if params[:id]
  end
end
