# encoding: utf-8
class ZipFile < ActiveRecord::Base

  default_scope  order: 'id desc'

  attr_accessible :name,:file,:download
  mount_uploader :file, FileUploader



end