require 'uri'
require "net/http"
require "json"

class PhotosController < ApplicationController
  before_action :logged_in_user
  AUTHORIZE_URL = '/oauth/authorize'
  TWEETS_URL = '/api/tweets'

  def index
  @photos = @current_user.photos&.sort&.reverse
  @my_tweet_app_url = my_tweet_app_url
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(
      title: params[:photo][:title],
      user_id: @current_user.id
    )
    if image = params[:photo][:image]
      @photo.image.attach(image)
    end
    
    if @photo.save
      flash[:notice] = '写真を投稿しました!'
      redirect_to '/photos'
    else
      flash[:danger] = @photo.errors.full_messages
      render('photos/new')
    end
  end

  def tweet
    photo = Photo.find( params[:id])
    return unless photo.present?

    res = post_tweet_req(photo)

    # 失敗した時用にログ出力
    if ['201','200'].exclude?(res.code) && res.body.present?
      puts JSON.parse(res.body)
      flash[:danger] = 'ツイートに失敗しました'
    else
      flash[:notice] = 'ツイートが完了しました!'
    end

    redirect_to photos_path
  end

  private

  def my_tweet_app_url
    uri = URI("http://#{DOMAIN}#{AUTHORIZE_URL}")
    request_params = {
      client_id: CLIENT_ID,
      response_type: 'code',
      redirect_uri: 'http://localhost:3000/oauth/callback',
      scope: 'write_tweet',
    }

    uri.query = request_params.to_param
    uri.to_s
  end

  def post_tweet_req(photo)
    uri = URI.parse("http://#{DOMAIN}#{TWEETS_URL}")
    request_params = {
      "text": photo.title,
      "url":  "http://localhost:3000#{rails_storage_proxy_path(photo.image)}",
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === "https"

    req = Net::HTTP::Post.new(uri.path)
    req["Authorization"] = "bearer #{session['access_token']}"
    req["Content-Type"] = "application/json"
    req.set_form_data(request_params)
   
    res = http.request(req)
  end
end
