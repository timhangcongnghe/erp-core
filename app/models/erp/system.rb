require 'google_drive'
module Erp
  class System < ActiveRecord::Base
    def self.columns
      @columns ||= [];
    end

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
        sql_type.to_s, null)
    end

    def save(validate = true)
      validate ? valid? : true
    end

    def self.backup(params)
      bk_dir = params[:backup_dir]
      Dir.mkdir(bk_dir) unless File.exists?(bk_dir)
      root_dir = params[:dir].present? ? params[:dir] : ""
      database = params[:database_name]
      revision_max = 0
      @files = Dir.glob("#{bk_dir}/*").sort{|a,b| b <=> a}
      @files.each_with_index do |f,index|
        if index > revision_max-1
          `rm -rf #{f}`
        end
      end
      dir = Time.now.strftime('%Y_%m_%d_%H%M%S')
      dir += "_#{database}"
      dir += '_db' if !params[:database].nil?
      dir += '_source' if !params[:file].nil?
      backup_cmd = "rm -f #{root_dir}data.dump && "
      backup_cmd += "pg_dump #{database} >> #{root_dir}data.dump && " if params[:database].present?
      backup_cmd += "zip -r #{bk_dir}/#{dir}.zip #{root_dir}data.dump" if !params[:file].nil? && File.directory?("#{root_dir}")
      puts backup_cmd
      `#{backup_cmd} &`
      if !File.directory?(dir)
        `rm -rf #{bk_dir}/#{dir}`
      end
    end

    def self.upload_backup_to_google_drive(params)
      bk_dir = params[:backup_dir]
      root_dir = params[:dir].present? ? params[:dir] : ''
      revision_max = params[:revision_max]
      backup_folder_name = 'timhangcongnghe.com'
      latest_backup_file = nil
      (Dir.glob("#{bk_dir}/*").sort{|a,b| b <=> a}).each do |f|
        if f.include?('.zip')
          latest_backup_file = f
          break
        end
      end
      return if latest_backup_file.nil?
      file_name = latest_backup_file.split("/").last
      puts 'Uploading... ' + latest_backup_file
      session = GoogleDrive::Session.from_config(params[:token])
      folder = session.collection_by_title(backup_folder_name)
      if !folder.present?
        folder = session.root_collection.create_subcollection(backup_folder_name)
      end
      files = folder.files
      if files.find { |file| file.title == file_name }
        puts 'file exists!'
        return
      end
      folder.upload_from_file(latest_backup_file, file_name, convert: false)
      files = folder.files
      count = files.count
      files.each_with_index do |file,index|
      if index >= revision_max
          puts "Deleting old backup... #{file.title}"
          file.delete(true)
        end
      end
      puts 'done'
    end
  end
end