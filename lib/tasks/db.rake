# https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90
namespace :db do

  desc "Dumps the database to backups"
  task :dump => :environment do
    backup_dir = backup_directory true
    cmd = with_config do |db, user|
      date = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
      [
        "pg_dump",
        "--verbose",
        "--username", user,
        "--dbname", db,
        "--format=c",
        "--file", "#{backup_dir}/#{date}_#{db}.psql",
      ]
    end
    sh(*cmd, verbose: true)
  end

  desc "Restores the database from backups"
  task :restore, [:date] => :environment do |task, args|
    fail 'Please pass a date to the task' if args.date.blank?

    backup_dir = backup_directory false
    cmd = with_config do |db, user|
      [
        "pg_restore",
        "--verbose",
        "--username", user,
        "--dbname", db,
        "--format=c",
        "--no-owner",
        "--no-acl",
        "#{backup_dir}/#{args.date}_#{db}.psql",
      ]
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    sh(*cmd, verbose: true)
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
    yield ActiveRecord::Base.connection_config.values_at(:database, :username)
  end
end
