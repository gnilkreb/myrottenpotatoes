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
#session.clear

    if ((params[:commit] == nil) && (params[:query] == nil) &&
        (session[:remR2] || session[:ratings] || session[:sortedby])) then
      redirect_to :action => 'indexfixup'
    end

    @all_ratings = Movie.select(:rating).map(&:rating).uniq
    params[:all_ratings] = @all_ratings
    @r = params[:remR1]? params[:remR1] : []

    if params[:ratings]
#      flash[:notice] = "#{params[:ratings].keys}"
      @r = params[:ratings].keys
#      flash[:notice] = "#{@r}"
      session[:ratings] = params[:ratings]
    end
    @remR1 = @r
    @movies = Movie.where( :rating => @r )

    params[:sortedby] = params[:query] ? params[:query] : session[:sortedby]
    if (params[:query])
      if (params[:query] == "title")
        @movies = @movies.sort_by!{ |m| m.title }
        params[:sortedby] = "title"
        session[:sortedby] = params[:sortedby]
      end
      if (params[:query] == "date")
        @movies = @movies.sort_by!{ |m| m.release_date }
        params[:sortedby] = "date"
        session[:sortedby] = params[:sortedby]
      end
    end

    @remR2 = Hash.new
    @all_ratings.each {  |r|
      @remR2[r] = @r.include?(r)?  true : false
    }

    params[:remR2] = @remR2
    session[:remR2] = params[:remR2]

  end

  def indexfixup
    params[:ratings] = session[:ratings]
    params[:query] = session[:sortedby]
    params[:sortedby] = session[:sortedby]
    session.clear
    flash.keep
    redirect_to :action => "index", :controller => "movies", :ratings => params[:ratings] , :query => params[:sortedby]
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
