module GjbApi
  class API < Grape::API
    format :json
    content_type :json, 'application/json'

    before do
      my_logger ||= Logger.new("#{Rails.root}/log/my.log")
      # my_logger.info env
      my_logger.info env['X-Real-IP']

      # puts env
      #
      # puts request
      #
      # puts  request.env['HTTP_X_FORWARDED_FOR']
      # puts env["action_dispatch.remote_ip"]
    end


    get :api do
      {status: 0}
    end

    # 从根开始截获全部不匹配的 url
    prefix '/'
  end

end