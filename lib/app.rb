require "sinatra"
require "sinatra/reloader" if development?
require "sqlite3"
require "pry-byebug"
require "better_errors"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

set :bind, '0.0.0.0'

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))

def artists(db)
  db.execute("SELECT artists.id, artists.name FROM artists")
end

get "/" do
  # TODO: Gather all artists to be displayed on home page
  @artists = artists(DB)
  erb :home # Will render views/home.erb file (embedded in layout.erb)
end

# Then:
# 1. Create an artist page with all the albums. Display genres as well
get '/artists/:id' do
  params[:id]
  erb :artists
end

# 2. Create an album pages with all the tracks
get '/albums/:id' do
  params[:id]
  erb :albums
end

# 3. Create a track page, and embed a Youtube video (you might need to hit Youtube API)
get '/tracks/:id' do
  params[:id]
  erb :tracks
end
