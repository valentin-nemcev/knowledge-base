node.set['tz'] = 'Europe/Moscow'
include_recipe 'timezone-ii'


include_recipe 'ruby_build'
include_recipe 'ruby_rbenv::system_install'


rbenv_ruby '2.3.0'
rbenv_global '2.3.0'

rbenv_gem 'bundler'


# https://github.com/hw-cookbooks/postgresql/issues/323
node.set['postgresql'] = {
  password: {'postgres' => ''},
  config: {'ssl' => 'false'},
  version: '9.5',
  dir: '/etc/postgresql/9.5/main',
  client: {
    packages: ['postgresql-client-9.5','libpq-dev']
  },
  server: {
    packages: ['postgresql-9.5']
  },
  contrib: {
    packages: ['postgresql-contrib-9.5'],
  },
  pg_hba: [
    { type: 'local', db: 'all', user: 'all', addr: '', method: 'trust' },
  ]
}
include_recipe 'postgresql::server'
include_recipe 'postgresql::client'


node.set[:dbuser] = 'vagrant'

execute "create-database-user" do
  userexists = <<-EOH
  psql -U postgres -c "select * from pg_user where usename='#{node[:dbuser]}'" | grep -c #{node[:dbuser]}
  EOH
  command "createuser -U postgres -sw #{node[:dbuser]}"
  not_if userexists
end

include_recipe 'nodejs'
