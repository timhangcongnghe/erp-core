require 'active_record'
require 'yaml'
DIR = File.expand_path(File.dirname(__FILE__))
require DIR+'/app/models/erp/system.rb'
Erp::System.upload_backup_to_dropbox({backup_dir: DIR+'/../../backup', dir: DIR+'/../../', token: 'C4qggMDIfSAAAAAAAAABnrwKgfvQo_LfczsUapuDTKm2Sni6cbUaDn8DU_kajGTu'})