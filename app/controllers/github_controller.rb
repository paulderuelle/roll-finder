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

      repositories_with_gemfile = user_repositories_with_gemfile(token)
      @repositories_with_gemfile = repositories_with_gemfile

      # repositories = user_repositories(token)

      # @render = "Successfully authorized! Welcome, #{@name} (#{@handle})."
      # repositories.each do |repo|
      #   @render += repo['name'].to_s
      # end

    else
      @render = "Authorized, but unable to exchange code #{code} for token."
    end
  end
end
