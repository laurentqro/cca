class ActivitiesController < ApplicationController
  def index
    @activities = current_user.activities.order('created_at desc')
  end
end
