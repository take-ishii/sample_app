require 'net/http'
require 'uri'
require 'json'

module Api
  module V1
    module Users
      class RelationshipsController < ApplicationController
        # createに対してのCSRF対策がオフになってない可能性があるので、デプロイ後の検証で引っかかったらここをチェック
        protect_from_forgery except: :create

        def create
          
        end

        private

          def request_session_validations(_user_id)
            uri = URI.parse("http://localhost:3000/api/v1/users/#{_user_id}/session_validations")
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = uri.scheme == 'https'
            headers = { "Content-Type": 'application/json' }
            authenticate_with_http_token do |token, _options|
              headers['Authorization'] = "Token #{token}"
            end
            response = http.get(uri.path, headers)
            response.code
          end
      end
    end
  end
end
