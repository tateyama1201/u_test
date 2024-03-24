require 'uri'
class PhotosController < ApplicationController
  before_action :logged_in_user

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
end
