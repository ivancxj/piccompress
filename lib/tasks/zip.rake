#encoding: utf-8
require 'zip/zip'
#namespace :zip do
  desc 'zip 解压'
  task :zip => :environment do

    folder = "/Users/ivan/low-res"

    source_path = '/Users/ivan/low-res/zip.zip'
    to_path = '/Users/ivan/low-res/'
    file_path = '/Users/ivan/low-res/zip/'

    #`unzip -n "#{source_path}" -d "#{to_path}"`

    Dir[File.join(file_path, '**', '**')].each do |file|
      if File.directory? file
        p "文件夹 #{file}"
      #  gm mogrify  -resize 50% 20130905_141715.jpg

      else
        p file
        `gm mogrify -resize 50% "#{file}" `
      end

    end

    #if File.directory? file_path
    #    Dir.foreach(file_path) do |file|
    #      if file!='.' and file!='..' and file!='.DS_Store'
    #        if File.directory? file
    #          p "文件夹 #{file}"
    #          Dir.foreach("#{file_path}#{file}") do |file_file|
    #            p "文件 #{file_file}"
    #          end
    #        else
    #          p "文件 #{file}"
    #
    #        end
    #
    #      end
    #    end
    #end
    #Zip::ZipFile.open(source_path) do |zf|
    #  zf.each do |e|
    #    next if e.name =~ /__MACOSX/ or e.name =~ /\.DS_Store/ or !e.file?
    #    new_path = File.join(tmp_dir, Pathname.new(e.name).basename)
    #    zf.extract(e.name, new_path)
    #    #self.images.build({:foo_id => id, :source => File.open(new_path)})
    #  end
    #end

    #Zip::ZipFile.open(source_path) do |zipfile|
    #  p '111'
    #  #zipfile.extract('somefile.csv', 'somefile.csv') {true}
    #end
  end
#end
