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

def albums(db, artist_id)
  db.execute("
    SELECT albums.id, albums.title, artists.name
    FROM albums
    JOIN artists ON albums.artist_id = artists.id
    WHERE artist_id = #{artist_id}
  ")
end

def tracks(db, album_id)
  db.execute("
    SELECT tracks.id, tracks.name, albums.title
    FROM tracks
    JOIN albums ON tracks.album_id = albums.id
    WHERE album_id = #{album_id}
  ")
end

get "/" do
  # TODO: Gather all artists to be displayed on home page
  @artists = artists(DB)
  erb :home # Will render views/home.erb file (embedded in layout.erb)
end

# Then:
# 1. Create an artist page with all the albums. Display genres as well
get '/artists/:id' do
  @albums = albums(DB, params[:id])
  erb :artists
end

# 2. Create an album pages with all the tracks
get '/albums/:id' do
  @tracks = tracks(DB, params[:id])
  erb :albums
end

# 3. Create a track page, and embed a Youtube video (you might need to hit Youtube API)
get '/tracks/:id' do
  @track = params[:id]
  erb :tracks
end
