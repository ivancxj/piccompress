# encoding: utf-8
require "carrierwave"
require 'carrierwave/processing/mini_magick'
class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # 性能压缩提升30%
  MiniMagick.processor = :gm


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # "/home/mzoneapp/api_v1/public/#{model.class.to_s.underscore}"
    "uploads/#{model.class.to_s.underscore}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # "photo/#{version_name}.jpg"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  #  http://kb.cnblogs.com/page/82967/
  #  使用gm 的用法 -thumbnail '100x100^'
  #  gm convert input.jpg -thumbnail '100x100^' -gravity center -extent 100x100 output_3.jpg
  def my_resize_to_fill(width, height, gravity = 'Center')
    manipulate! do |img|
      cols, rows = img[:dimensions]
      img.combine_options do |cmd|
        if width != cols || height != rows
          scale_x = width/cols.to_f
          scale_y = height/rows.to_f
          if scale_x >= scale_y
            cols = (scale_x * (cols + 0.5)).round
            rows = (scale_x * (rows + 0.5)).round
            cmd.resize "#{cols}"
          else
            cols = (scale_y * (cols + 0.5)).round
            rows = (scale_y * (rows + 0.5)).round
            cmd.resize "x#{rows}"
          end
        end
        cmd.gravity gravity
        # 多余的部分用白色代替
        cmd.background "rgba(255,255,255,0.0)"
        # 关键就是 thumbnail  后面 ^ 就能达到我们的需求 !!!!!
        cmd.thumbnail "#{width}x#{height}^" if cols != width || rows != height
        cmd.extent "#{width}x#{height}" if cols != width || rows != height
      end
      img = yield(img) if block_given?
      img
    end
  end

  #品质设置 plane
  def plane_pic
    manipulate! do |img|
      #img.quality(percentage.to_s)
      #img = yield(img) if block_given?

      img.strip
      img.combine_options do |c|
        # Use Progressive DCT Instead of Baseline DCT.
        c.interlace 'plane'
      end

      img
    end
  end
end