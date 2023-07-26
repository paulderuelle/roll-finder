class GithubController < ApplicationController
  skip_before_action :authenticate_user!
  include GitAuthHelper
  def index
    @link = "https://github.com/login/oauth/authorize?client_id=#{CLIENT_ID}"
  end
  def callback
    code = params["code"]
    token_data = exchange_code(code)
    if token_data.key?("access_token")
      token = token_data["access_token"]
      user_info = user_info(token)
      @handle = user_info["login"]
      @name = user_info["name"]
      @render = "Successfully authorized! Welcome, #{@name} (#{@handle})."
    else
      @render = "Authorized, but unable to exchange code #{code} for token."
    end
  end
end
