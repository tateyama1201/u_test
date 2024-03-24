require "net/http"
require "json"
require 'uri'

class OauthController < ApplicationController

  def callback
    ## codeが返ってきているようならアクセストークンリクエストをする
    if params[:code].present?
      res = otoken_post_req
      # 失敗した時用にログ出力
      if res.code != '200'
        puts JSON.parse(res.body)
        return
      end

      res_body = JSON.parse(res.body)

      session['access_token'] = res_body['access_token']

      flash[:notice] = '連携が完了しました!'
      redirect_to photos_path
    else
      raise 'error'
    end
  end

  private

  def otoken_post_req
    uri = URI.parse("http://#{DOMAIN}#{TOKEN_URL}")
    request_params = {
      grant_type: 'authorization_code',
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      code: params[:code],
      redirect_uri: 'http://localhost:3000/oauth/callback',
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === "https"

    headers = { "Content-Type" => "application/x-www-form-urlencoded" }
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(request_params)
    req.initialize_http_header(headers)
    res = http.request(req)
  end
end
