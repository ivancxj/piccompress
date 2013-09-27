#encoding: utf-8
require 'carrierwave'
require 'carrierwave/processing/mini_magick'
require 'zip/zip'
class FileUploader < CarrierWave::Uploader::Base
  #include CarrierWave::MiniMagick
  #MiniMagick.processor = :gm

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  def extension_white_list
    %w(zip)  # TODO 目前只支持zip
  end

  after :store, :unzip

  def unzip(file) # 直接解压出目录

    # 上传的后缀
    extname =  File.extname(filename)
    # 上传的去掉后缀的名字
    basename =  File.basename(filename,extname)

    # 安装7z   brew install unrar
    # /Users/ivan/.homebrew/Cellar/unrar/4.2.4/bin/unrar x
    # 解压
    `unzip -n "#{current_path}" -d "#{File.dirname(current_path)}/#{basename}"`

    file_path =  "#{File.dirname(current_path)}/#{basename}"
    Dir[File.join(file_path, '**', '**')].each do |file|
      if File.file? file
        base =  File.extname(file).downcase
        if base.eql? '.jpg' or base.eql? '.jpeg' or base.eql? '.png'
          dimensions = MiniMagick::Image.open(file)

          # 取宽高的最大值
          max = dimensions['width']
          if max < dimensions['height']
            max = dimensions['height']
          end

          if max <= 150
            # 图片很小就不要处理
          elsif max <= 1000
            `gm mogrify -resize 99% "#{file}" `
          else
            size = (100000/max.to_f).round
            size = 99 if size > 99   # 不能超过100压缩
            p "max=#{max} size=#{size}"
            `gm mogrify -resize #{size}% "#{file}" `
          end

        end
      end
    end

    # 重新打包 并另命名
    archive = "#{File.dirname(current_path)}/#{basename}_out#{extname}"
    #file_path.sub!(%r[/$],'')
    FileUtils.rm archive, :force=>true
    Zip::ZipFile.open(archive, 'w') do |zipfile|
      Dir["#{file_path}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(file_path+'/',''),file)
      end
    end

    model.download = "#{store_dir}/#{basename}_out#{extname}"
    model.save
    #FileUtils.rmdir file_path

  end
end
