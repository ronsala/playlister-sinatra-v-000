# require 'rack-flash'

class SongsController < ApplicationController

  # use Rack::Flash

  get "/songs" do
    @songs = Song.all
    erb :"songs/index"
  end
  
  get "/songs/new" do
    @genres = Genre.all
    @artists = Artist.all
    erb :'songs/new'
  end

  get "/songs/:slug/edit" do
    @song = Song.find_by_slug(params[:slug])
    @genres = Genre.all
    # binding.pry
    erb :'songs/edit'
  end

  get "/songs/:slug" do
    @song = Song.find_by_slug(params[:slug])
    artist_id = @song.artist_id
    @artist = Artist.find(artist_id)
    # binding.pry
    erb :'songs/show'
  end

  post "/songs" do
    
    @song = Song.create(name: params[:Name])
    
    params[:genres].each do |id|
      @song.genres << Genre.find_by_id(id)
    end
    
    @artist = Artist.find_or_create_by(name: params["Artist Name"])

    @artist.songs << @song
    @artist.save
    @song.save

    # flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    # binding.pry
    unless params[:song_name].empty?
      # binding.pry
      @song.update(:name => params[:song_name])
    end

    # unless params[:artist_name].empty?
    #   # binding.pry
    #   @artist = Artist.find_or_create_by(:name => params[:artist_name])
    #   @artist.songs << @song
    #   @artist.save
    # end

      # @artist = Artist.find_or_create_by(:name => params[:artist_name])
      # # binding.pry
      # @song.artist << @artist

    params[:genres].each do | g |
      # binding.pry
      genre = Genre.find(g)
      if !@song.genres.include?(genre)
        @song.genres << genre
      end
    end
    @song.save

    # flash[:message] = "Successfully updated song."
    redirect to "/songs/#{@song.slug}"
  end

end
