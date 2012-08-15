class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def sort_by_title
    @movies = Movie.all
  end

  def index

    @all_ratings = Movie.select(:rating).map(&:rating).uniq
    params[:all_ratings] = @all_ratings
    @r = params[:remR1]? params[:remR1] : []
    @remR1 = @r
    if params[:ratings]
#      flash[:notice] = "#{params[:ratings].keys}"
      @r = params[:ratings].keys
#      flash[:notice] = "#{@r}"
    end

    @movies = Movie.where( :rating => @r )

    params[:sortedby] = ""
    if (params[:query])
      if (params[:query] == "title")
        @movies = @movies.sort_by!{ |m| m.title }
        params[:sortedby] = "title"
      end
      if (params[:query] == "date")
        @movies = @movies.sort_by!{ |m| m.release_date }
        params[:sortedby] = "date"
      end
    end

    @remR2 = Hash.new
    @all_ratings.each {  |r|
      @remR2[r] = @r.include?(r)?  true : false
    }
    params[:remR2] = @remR2

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
