namespace :db do
  desc 'Create database'
  task :create do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "db:create"
        end
      end
    end
  end

  desc 'Migrate database'
  task :migrate do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "db:migrate"
        end
      end
    end
  end
end
