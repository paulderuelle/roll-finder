require "dotenv/load"
require "net/http"
require "json"
require "debug"

module GitAuthHelper
  Dotenv.overload
  CLIENT_ID = ENV.fetch("CLIENT_ID")
  CLIENT_SECRET = ENV.fetch("CLIENT_SECRET")

  def parse_response(response)
    case response
    when Net::HTTPOK
      JSON.parse(response.body)
    else
      puts response
      puts response.body
      {}
    end
  end

  def exchange_code(code)
    params = {
      "client_id" => CLIENT_ID,
      "client_secret" => CLIENT_SECRET,
      "code" => code
    }
    result = Net::HTTP.post(
      URI("https://github.com/login/oauth/access_token"),
      URI.encode_www_form(params),
      { "Accept" => "application/json" }
    )

    parse_response(result)
  end

  def user_info(token)
    uri = URI("https://api.github.com/user")

    result = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      body = { "access_token" => token }.to_json

      auth = "Bearer #{token}"
      headers = { "Accept" => "application/json", "Content-Type" => "application/json", "Authorization" => auth }

      http.send_request("GET", uri.path, body, headers)
    end

    parse_response(result)
  end

  # def user_repositories(token)
  #   uri = URI("https://api.github.com/user/repos")

  #   result = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
  #     auth = "Bearer #{token}"
  #     headers = { "Accept" => "application/json", "Authorization" => auth }

  #     http.send_request("GET", uri.path, nil, headers)
  #   end

  #   parse_response(result)
  # end

  def user_repositories_with_gemfile(token)
    uri = URI("https://api.github.com/user/repos")

    result = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      auth = "Bearer #{token}"
      headers = { "Accept" => "application/json", "Authorization" => auth }

      http.send_request("GET", uri.path, nil, headers)
    end

    repositories = parse_response(result)

    repositories_with_gemfile = []
    repositories.each do |repo|
      gemfile = fetch_gemfile_content(token, repo['full_name'])
      repositories_with_gemfile << { 'name' => repo['name'], 'gemfile' => gemfile } if gemfile
    end

    repositories_with_gemfile
  end

  def fetch_gemfile_content(token, repo_full_name)
    uri = URI("https://api.github.com/repos/#{repo_full_name}/contents/Gemfile")

    result = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      auth = "Bearer #{token}"
      headers = { "Accept" => "application/json", "Authorization" => auth }

      http.send_request("GET", uri.path, nil, headers)
    end

    content_response = parse_response(result)
    return Base64.decode64(content_response["content"]) if content_response.key?("content")
  end
end
