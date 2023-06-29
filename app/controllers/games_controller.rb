require 'open-uri'
require 'nokogiri'

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

    Game.create!(
      name: game_name,
      publish_year: game_data.at_xpath('//yearpublished').text,
      description: game_data.at_xpath('//description').text,
      min_players: game_data.at_xpath('//minplayers').text,
      max_players: game_data.at_xpath('//maxplayers').text,
      duration: game_data.at_xpath('//playingtime').text.to_i
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
        name: game.at_xpath('./name').text,
        id: game_id,
        year_published: game_data.at_xpath('//yearpublished').text,
        min_players: game_data.at_xpath('//minplayers').text,
        max_players: game_data.at_xpath('//maxplayers').text,
        playing_time: game_data.at_xpath('//playingtime').text,
        description: game_data.at_xpath('//description').text,
        image: game_data.at_xpath('//image')&.text
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
end
