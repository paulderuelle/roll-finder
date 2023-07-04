require 'open-uri' # Import the library for opening URLs
require 'nokogiri' # Import the library for parsing XML and HTML
require 'cloudinary' # Import the library for working with cloud-based images
require 'cgi' # Import the library for URL encoding. For exemple: "Hello, World!" => "Hello%2C+World%21"
require 'htmlentities' # Import the library for decoding HTML entities. For exemple: "&amp;" => "&"

class GamesController < ApplicationController
  # Execute the fetch_game method before the my_game action
  # before_action :fetch_game, only: [:my_game]

  def index
    # Retrieve games from the Game model and randomize the order
    @games = Game.order(Arel.sql('RANDOM()'))
  end

  def show
    # Get the search_query parameter from the request
    search_query = params[:search_query]
    # Search for games based on the search_query
    @games = search_games(search_query)
    # Store the search_query for use in the view
    @search_query = search_query
    # Save the searched games to the database
    save_games(@games)
    # Retrieve the saved games from the database based on their names
    @games = Game.where(name: @games.pluck(:name))
  end

  # def my_game
  #   # Update the switched_button attribute of the @game object
  #   @game&.update(switched_button: !@game.switched_button)
  #   # Redirect to a new event path
  #   redirect_to new_event_path
  # end

  private

  # See line 8 for method usage
  # def fetch_game
  #   # Find the game from the Game model based on the game_name parameter
  #   @game = Game.find_by(name: params[:game_name])
  # end

  # See line 19 for method usage
  def search_games(query)
    # Encode the search query. For exemple: "Hello, World!" => "Hello%2C+World%21"
    encoded_query = CGI.escape(query)
    # Build the URL for the API
    url = "https://www.boardgamegeek.com/xmlapi/search?search=#{encoded_query}&exact=1"
    # Fetch the XML data from the API and extract the boardgame
    fetch_xml_data(url).xpath('//boardgame').map do |game|
      # Build a game object with attributes
      build_game_object(game)
    end
  end

  # See line 52 for method usage
  def build_game_object(game)
    # Fetch the game data for a specific game from the API
    game_data = fetch_game_data(game['objectid'])
    # Build a hash object with the game attributes
    fetch_game_attributes(game, game_data)
  end

  # See line 61 for method usage
  def fetch_game_attributes(game, game_data)
    {
      # Fetch the primary name attribute from the XML data
      name: fetch_value(game, './name[@primary="true"]'),
      # Fetch the game ID
      id: game['objectid'],
      # Fetch the year published attribute from the XML data, etc...
      year_published: fetch_value(game_data, '//yearpublished'),
      min_players: fetch_value(game_data, '//minplayers'),
      max_players: fetch_value(game_data, '//maxplayers'),
      playing_time: fetch_value(game_data, '//playingtime'),
      description: fetch_value(game_data, '//description'),
      image: fetch_value(game_data, '//image')
    }
  end

  # See line 89 for method usage
  def fetch_xml_data(url)
    # Fetch the XML data from the specified URL
    Nokogiri::XML(URI.open(url))
  end

  # See line 59 & 129 for method usage
  def fetch_game_data(game_id)
    # Fetch the game data for game from API
    fetch_xml_data("https://www.boardgamegeek.com/xmlapi/boardgame/#{game_id}")
  end

  # See methods at line 65 and 144 for method usage
  def fetch_value(xml_data, xpath)
    if xpath == './name'
      # Fetch the primary name attribute from the XML data
      fetch_name_value(xml_data, xpath)
    elsif xpath == '//description'
      # Fetch and process the description attribute from the XML data
      fetch_description_value(xml_data)
    else
      # Fetch the value based on the provided XPath from the XML data
      xml_data.at_xpath(xpath)&.text
    end
  end

  # See line 97 for method usage
  def fetch_name_value(xml_data, xpath)
    # Fetch the primary name attribute from the XML data
    xml_data.at_xpath("#{xpath}[@primary='true']")&.text
  end

  # See line 100 for method usage
  def fetch_description_value(xml_data)
    # Create a new HTMLEntities object to decode HTML entities
    coder = HTMLEntities.new
    # Fetch the description attribute from the XML data
    text = xml_data.at_xpath('//description')&.text
    # Remove HTML tags from the description
    text = text.gsub(/<[^>]*>/, '') if text
    # Replacing HTML entities with their corresponding characters
    text = coder.decode(text) if text
    # Remove specific sentence from the description
    text = text.gsub("Description from the publisher:", '') if text
    # Split the description into sentences
    sentences = text.split(/(?<=[.:!?])\s+/)
    # Get the first sentence from the description only
    sentences.first.strip
  end

  # See line 23 for method usage
  def save_games(games)
    games.each do |game|
      # Fetch the game data for a specific game from the API
      game_data = fetch_game_data(game[:id])
      # Check if a game with the same name and publish year already exists
      existing_game = Game.find_by(name: game[:name], publish_year: fetch_value(game_data, '//yearpublished'))

      # Skip saving if the game already exists (based on name & publish year to avoid duplication if same name)
      next if existing_game.present?

      # Upload the game image to Cloudinary and get the image URL
      image_url = upload_image_to_cloudinary(game[:image])
      # Create a new Game record in the database
      create_game(game, game_data, image_url)
    end
  end

  # See line 146 for method usage
  def create_game(game, game_data, image_url)
    Game.create!(
      # Set the game name attribute, year published, description, etc...
      name: game[:name],
      publish_year: fetch_value(game_data, '//yearpublished'),
      description: fetch_value(game_data, '//description'),
      min_players: fetch_value(game_data, '//minplayers'),
      max_players: fetch_value(game_data, '//maxplayers'),
      duration: fetch_value(game_data, '//playingtime').to_i,
      image_url: image_url
    )
  end

  # See line 144 for method usage
  def upload_image_to_cloudinary(image_url)
    # Upload the game image to Cloudinary and return the secure URL
    Cloudinary::Uploader.upload(image_url)['secure_url']
  end
end

# Games Controller logic & Definition of Done // User Test Acceptance =>
#   As a user I would like to select or search for a game to create a new event
# The search querry is using boardgamegeek API
#   boardgamegeek API has a 2 steps process:
#     1/ Based on an exact name search (&exact=1), see *** below, it provides the boardgame name & object ID (url#1)
#     2/ Based on the boardgame object ID we can extract several informations (url#2)
#     => Extracted informations: yearpublished, min&max players, playingtime & image
#     => Description from the API is reformated (removing HTML) and just the 2 first sentences are saved
# As soon as the search is performed with a match from the API, the info are saved into the database
#   The save to database process is transparent for the user
#     The goal is to have users populating the database step by step to avoid regular hits on the API
#     The images are stored on Cloudinary too to avoid regular hits on the API
#     If the search is matching with a result from the database, data from database are used for the views
# Either from the index or from the show (search result), user can create an new event
#   The games paramaters are encapsulated & sent (with the button) to the new event creation form
# The querry has to be formated&enchanced to find more matches from the API
#   The API has some limitation and some search won't return any result
#     The API "optimization" could be handled and enhanced by the boardgamegeek team (or community)
#     *** Removing "&exact=1" will provide more results (not displayed) but it has critical impact on the responsiveness
#     *** The application will freeze even if some games are saved into the database behind the scene
#     *** Huge & critical impact on the user experience // TO BE AVOIDED
