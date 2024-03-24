class PhotosController < ApplicationController
  before_action :logged_in_user

  def index
  @photos = @current_user.photos&.sort&.reverse
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
end
