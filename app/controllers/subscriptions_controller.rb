class SubscriptionsController < ApplicationController
  before_action :load_subscribeable

  def create
    subscription = @subscribeable.subscriptions.new(user_id: current_user.id)

    if subscription.save
      redirect_to @subscribeable
    else
      redirect_to @subscribeable
    end
  end

  def destroy
    subscription = Subscription.find(params[:id])
    subscription.destroy

    redirect_to @subscribeable
  end

  private

  def load_subscribeable
    resource, id = request.path.split('/')[1, 2]
    @subscribeable = SUBSCRIBEABLE[resource].find(id)
  end

  SUBSCRIBEABLE = {
    "projets" => Project
  }
end
