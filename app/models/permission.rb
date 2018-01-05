class Permission
  def initialize(user)
    allow_action 'users/sessions',      [:new, :create]
    allow_action 'users/registrations', [:new, :create]
    allow_action 'users/passwords',     [:new, :create, :edit, :update]

    if user.present?
      allow_all               if user.admin?
      allow_action :users,    :show
      allow_action :projects, :index
      allow_action 'users/sessions', :destroy
      allow_action 'users/registrations', [:edit, :update]

      if user.partner?
        allow_action :projects, :index
        allow_action :projects, :show do |project|
          project.user_ids.include?(user.id)
        end
      end

      if user.employee?
        allow_action :archives,    :index
        allow_action :assignments, [:create, :destroy]
        allow_action :projects,    [:index, :show]
        allow_action :users,       [:index, :show]
      end
    end
  end

  def allow_action?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
  end

  def allow_all
    @allow_all = true
  end

  def allow_action(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end

  def allow_param(resources, attributes)
    @allowed_params ||= {}
    Array(resources).each do |resource|
      @allowed_params[resource.to_s] ||= []
      @allowed_params[resource.to_s] += Array(attributes).map(&:to_s)
    end
  end

  def allow_param?(resource, attribute)
    if @allow_all
      true
    elsif @allowed_params && @allowed_params[resource.to_s]
      @allowed_params[resource.to_s].include?(attribute.to_s)
    end
  end

  def permit_params!(params)
    if @allow_all
      params.permit!
    elsif @allowed_params
      @allowed_params.each do |resource, attributes|
        if params[resource].respond_to?(:permit)
          params[resource] = params[resource].permit(*attributes)
        end
      end
    end
  end
end

