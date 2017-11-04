task :env do
  on roles(:all) do
    execute "env"
  end
end
