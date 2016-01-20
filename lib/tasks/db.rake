# https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90
namespace :db do

  desc "Dumps the database to backups"
  task :dump => :environment do
    backup_dir = backup_directory true
    cmd = nil
    with_config do |app, db, user|
      cmd = "pg_dump -F c -v  -d #{db} -f #{backup_dir}/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{db}.psql"
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database from backups"
  task :restore, [:date] => :environment do |task,args|
    if args.date.present?
      backup_dir = backup_directory false
      cmd = nil
      with_config do |app, db, user|
        cmd = "pg_restore -F c -v -c -C #{backup_dir}/#{args.date}_#{db}.psql"
      end
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      puts cmd
      exec cmd
    else
      puts 'Please pass a date to the task'
    end
  end

  private

  def backup_directory create=false
    backup_dir = "#{Rails.root}/db/backups"
    if create and not Dir.exists?(backup_dir)
      puts "Creating #{backup_dir} .."
      Dir.mkdir(backup_dir)
    end
    backup_dir
  end

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end
end
