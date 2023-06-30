require 'open-uri'
require 'nokogiri'
require 'cloudinary'
require 'cgi'

class GamesController < ApplicationController
  before_action :fetch_game, only: [:my_game]

  def index
    @games = Game.order(:name)
  end

  def show
    search_query = params[:search_query]
    @games = search_games(search_query)
    @search_query = search_query

    save_games(@games)

    @games = Game.where(name: @games.pluck(:name))
  end

  def my_game
    @game.update(switched_button: !@game.switched_button) if @game
    redirect_to new_event_path
  end

  private

  def fetch_game
    @game = Game.find_by(name: params[:game_name])
  end

  def search_games(query)
    encoded_query = CGI.escape(query)
    fetch_xml_data("https://www.boardgamegeek.com/xmlapi/search?search=#{encoded_query}&exact=1").xpath('//boardgame').map do |game|
      game_data = fetch_game_data(game['objectid'])

      {
        name: fetch_value(game, './name[@primary="true"]'),
        id: game['objectid'],
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
    Nokogiri::XML(URI.open(url))
  end

  def fetch_game_data(game_id)
    fetch_xml_data("https://www.boardgamegeek.com/xmlapi/boardgame/#{game_id}")
  end

  def fetch_value(xml_data, xpath)
    if xpath == './name'
      text = xml_data.at_xpath(xpath + '[@primary="true"]')&.text
    else
      text = xml_data.at_xpath(xpath)&.text
    end

    if xpath == '//description'
      text = text.gsub(/<[^>]*>/, '')

      sentences = text.split(/(?<=[.!?])\s+/)

      text = sentences.first(2).join(' ')
    end

    text
  end

  def save_games(games)
    games.each do |game|
      game_data = fetch_game_data(game[:id])
      existing_game = Game.find_by(name: game[:name], publish_year: fetch_value(game_data, '//yearpublished'))

      next if existing_game.present?

      image_url = upload_image_to_cloudinary(game[:image])

      Game.create!(
        name: game[:name],
        publish_year: fetch_value(game_data, '//yearpublished'),
        description: fetch_value(game_data, '//description'),
        min_players: fetch_value(game_data, '//minplayers'),
        max_players: fetch_value(game_data, '//maxplayers'),
        duration: fetch_value(game_data, '//playingtime').to_i,
        image_url: image_url
      )
    end
  end

  def upload_image_to_cloudinary(image_url)
    Cloudinary::Uploader.upload(image_url)['secure_url']
  end
end
