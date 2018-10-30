class Permission
  def initialize(user)
    allow_action 'users/sessions',      [:new, :create]
    allow_action 'users/registrations', [:new, :create]
    allow_action 'users/passwords',     [:new, :create, :edit, :update]
    allow_action 'users/invitations',   [:edit, :update]

    if user.present?
      allow_all                            if user.admin?
      allow_action :users,                 :show
      allow_action :projects,              :index
      allow_action 'users/impersonations', [:show, :destroy]
      allow_action 'users/sessions',       :destroy
      allow_action 'users/registrations',  [:edit, :update]
      allow_action 'activities', :index

      allow_action :documents, :destroy do |document|
        document.owned_by_user?(user)
      end

      allow_action :folders, :destroy do |folder|
        folder.owned_by_user?(user) && folder.contains_only_resources_owned_by_user?(user)
      end

      if user.partner?
        allow_action :projects, :index

        allow_action :projects, :show do |project|
          Assignment.exists?(project: project, user: user)
        end

        allow_action :folders, [:show, :create] do |folder|
          Assignment.exists?(project: folder.project, user: user)
        end

        allow_action :documents, :create do |document|
          Assignment.exists?(project: document.folder.project, user: user)
        end
      end

      if user.employee?
        allow_action :projects,    [:index, :show]
        allow_action :documents,   :create
        allow_action :folders,     [:show, :create]
        allow_action :companies,   [:index, :show, :new, :create, :edit, :update]
        allow_action :archives,    :index
        allow_action :assignments, :index
        allow_action 'api/assignments', [:create, :destroy]
        allow_action :employments, [:index, :create, :destroy]
        allow_action :users,       [:index, :show]

        allow_action :users,       [:edit, :update] do |another_user|
          another_user.partner?
        end

        allow_param :user,         [:active]
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

