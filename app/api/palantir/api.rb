module Palantir
  class API < Grape::API
    version 'v1', using: :header, vendor: 'palantir'
    format :json
    prefix :api

    helpers do
      def valid_api_key?
        return false unless header_token = headers['Authorization']
        header_token = header_token.split('=').last
        ApiKey.where(token: header_token).present?
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless valid_api_key?
      end
    end

    resource :images do
      desc "Create an image."

      post do
        authenticate!
        Image.create!(params['image'])
      end
    end
  end
end
