module GjbApi
  class API < Grape::API
    format :json
    content_type :json, 'application/json'

    before do
      my_logger ||= Logger.new("#{Rails.root}/log/my.log")
      # my_logger.info env
      my_logger.info env['REMOTE_ADDR']
    end


    get :api do
      {status: 0}
    end

    # 从根开始截获全部不匹配的 url
    prefix '/'
  end

end