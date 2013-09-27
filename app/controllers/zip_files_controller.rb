#encoding: utf-8
class ZipFilesController < ApplicationController
  def index
    @zip_files = ZipFile.limit(10)
    respond_to do |format|
      format.html
      format.json { render json: @zip_files }
    end
  end

  def show
    @zip_file = ZipFile.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @zip_file }
    end
  end

  def new
    @zip_file = ZipFile.new
    respond_to do |format|
      format.html
      format.json { render json: @zip_file }
    end
  end

  #def edit
  #  @zip_file = ZipFile.find(params[:id])
  #end

  def create
    @zip_file = ZipFile.new(params[:zip_file])
    respond_to do |format|
      if @zip_file.save
        format.html { redirect_to @zip_file, notice: '上传成功,马上开始无损压缩处理...' }
        format.json { render json: @zip_file }
      else
        format.html { render action: 'new' }
        format.json { render json: @zip_file.errors }
      end
    end
  end

  def destroy
    @zip_file = ZipFile.find(params[:id])
    @zip_file.destroy
    respond_to do |format|
      format.html { redirect_to zip_files_url }
      format.json { head :no_content }
    end
  end

end
