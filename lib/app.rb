require "sinatra"
require "sinatra/reloader" if development?
require "sqlite3"

set :bind, '0.0.0.0'

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))

get "/" do
  # TODO: Gather all artists to be displayed on home page
  erb :home # Will render views/home.erb file (embedded in layout.erb)
end

# Then:
# 1. Create an artist page with all the albums. Display genres as well
# 2. Create an album pages with all the tracks
# 3. Create a track page, and embed a Youtube video (you might need to hit Youtube API)

get '/' do
  @elements = ["artist/:id", "albums/:id", "tracks/:id" ]
  erb :index
end
