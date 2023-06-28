require 'open-uri' # Including the 'open-uri' library, which allows opening URLs
require 'nokogiri' # Including the 'nokogiri' gem, which provides XML parsing and manipulation capabilities

class GamesController < ApplicationController
  def index
    # Set the initial search query
    search_query = 'Space Hulk'

    # Call the search_games method with the search query and assign the result to @games
    @games = search_games(search_query)
  end

  def save_game
    game_id = params[:game_id]
    game_name = params[:game_name] # Add this line to retrieve the game name from the form

    # Use the game ID to retrieve the relevant game data
    game_data = fetch_game_data(game_id)

    # Create a new game record in the database using the retrieved data
    Game.create!(
      name: game_name, # Save the retrieved game name instead of the name from game_data (to avoid localized name usage)
      publish_year: game_data.at_xpath('//yearpublished').text,
      description: game_data.at_xpath('//description').text,
      min_players: game_data.at_xpath('//minplayers').text,
      max_players: game_data.at_xpath('//maxplayers').text,
      duration: game_data.at_xpath('//playingtime').text.to_i
    )

    redirect_to games_path, notice: 'Game saved successfully' # Redirect back to the index page
  end

  private

  def search_games(query)
    # Assign the URL for the game search API with the given query (exact=1)
    url = "https://www.boardgamegeek.com/xmlapi/search?search=#{query}&exact=1"

    # Fetch the XML data from the API URL
    xml_data = fetch_xml_data(url)

    # Map through each boardgame in the XML data and extract the informations
    xml_data.xpath('//boardgame').map do |game|
      # Get the game ID from the 'objectid' attribute of the boardgame element
      game_id = game['objectid']

      # Fetch the XML data for the specific game using its ID
      game_data = fetch_game_data(game_id)

      # Create a hash with the extracted information for the game
      {
        # Extract the name from the current boardgame element
        name: game.at_xpath('./name').text,
        # Store the game ID
        id: game_id,
        # Extract the year published from the game data
        year_published: game_data.at_xpath('//yearpublished').text,
        # Extract the minimum number of players from the game data
        min_players: game_data.at_xpath('//minplayers').text,
        # Extract the maximum number of players from the game data
        max_players: game_data.at_xpath('//maxplayers').text,
        # Extract the playing time from the game data
        playing_time: game_data.at_xpath('//playingtime').text,
        # Extract the description from the game data
        description: game_data.at_xpath('//description').text,
        # Extract the image URL from the game data
        image: game_data.at_xpath('//image').text
      }
    end
  end

  def fetch_xml_data(url)
    # Fetch the HTML file content from the specified URL
    html_file = URI.open(url).read

    # Parse the HTML file content as XML data using Nokogiri
    Nokogiri::XML.parse(html_file)
  end

  def fetch_game_data(game_id)
    # Construct the URL for the specific game's API using its ID
    game_url = "https://www.boardgamegeek.com/xmlapi/boardgame/#{game_id}"

    # Fetch the XML data for the game using its URL
    fetch_xml_data(game_url)
  end
end
