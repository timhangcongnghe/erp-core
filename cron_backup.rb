require 'active_record'
require 'yaml'
DIR = File.expand_path(File.dirname(__FILE__))
rails_env = ARGV[0]
# Change the following to reflect your database settings
# config = YAML.load_file(DIR+'/config/database.yml')["production"]
config = YAML.load_file(DIR+'/../../config/database.yml')[rails_env]

ActiveRecord::Base.establish_connection(
  adapter: config["adapter"],
  encoding: config["encoding"],
  database: config["database"],
  pool: 5,
  username: config["username"],
  password: config["password"]
)

#Item class
require DIR+'/app/models/erp/system.rb'

Erp::System.backup({
  database: true,
  file: true,
  database_name: config["database"],
  rails_env: rails_env,
  backup_dir: DIR+'/../../../backup',
  dir: DIR+'/../../'
})
