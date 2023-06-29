require 'open-uri'
require 'nokogiri'
require 'cloudinary'

class GamesController < ApplicationController
  def index
    @games = Game.order(:name)
  end

  def show
    search_query = params[:search_query]&.capitalize
    @games = search_games(search_query)
    @search_query = search_query
  end

  def save_game
    game_id = params[:game_id]
    game_name = params[:game_name]
    game_data = fetch_game_data(game_id)
    image_url = fetch_image_url(game_data)

    Game.create!(
      name: game_name,
      publish_year: fetch_value(game_data, '//yearpublished'),
      description: fetch_value(game_data, '//description'),
      min_players: fetch_value(game_data, '//minplayers'),
      max_players: fetch_value(game_data, '//maxplayers'),
      duration: fetch_value(game_data, '//playingtime').to_i,
      image_url: image_url
    )

    redirect_to games_path, notice: 'Game saved successfully'
  end

  def my_game
    game = Game.find_by(name: params[:game_name])

    if game
      game.update(switched_button: !game.switched_button)
    end

    redirect_to games_path
  end

  private

  def search_games(query)
    url = "https://www.boardgamegeek.com/xmlapi/search?search=#{query}&exact=1"
    xml_data = fetch_xml_data(url)

    xml_data.xpath('//boardgame').map do |game|
      game_id = game['objectid']
      game_data = fetch_game_data(game_id)

      {
        name: fetch_value(game, './name'),
        id: game_id,
        year_published: fetch_value(game_data, '//yearpublished'),
        min_players: fetch_value(game_data, '//minplayers'),
        max_players: fetch_value(game_data, '//maxplayers'),
        playing_time: fetch_value(game_data, '//playingtime'),
        description: fetch_value(game_data, '//description'),
        image: fetch_value(game_data, '//image')
      }
    end
  end

  def fetch_xml_data(url)
    html_file = URI.open(url).read
    Nokogiri::XML.parse(html_file)
  end

  def fetch_game_data(game_id)
    game_url = "https://www.boardgamegeek.com/xmlapi/boardgame/#{game_id}"
    fetch_xml_data(game_url)
  end

  def fetch_value(xml_data, xpath)
    xml_data.at_xpath(xpath)&.text
  end

  def fetch_image_url(game_data)
    image_url = fetch_value(game_data, '//image')

    if image_url.present?
      uploaded_image = Cloudinary::Uploader.upload(image_url)
      uploaded_image['secure_url']
    end
  end
end
