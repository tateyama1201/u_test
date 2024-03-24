class ApplicationController < ActionController::Base
  include SessionsHelper
  # 実際は環境変数で管理
  CLIENT_ID = 'AXPXYGGCR4TjDxxJzayo68ejjBNEesooTDowF01X4Lw'
  CLIENT_SECRET = 'rfFhhyzhyers4N_ZMxQN4cy3pmjzvMChEwazCcqaIzc'
  DOMAIN = 'unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com'

  private

  def logged_in_user
    unless logged_in?
      redirect_to login_url
    end
  end
end
