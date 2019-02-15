class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    @selected_ratings=['G','PG','PG-13','R']
    @sort_by=''
    @flag=0
    if params[:ratings]  #determine ratings and sort
      @flag=1
      @selected_ratings=params[:ratings].keys
      session[:ratings]=params[:ratings]
    elsif session[:ratings]
      @selected_ratings=session[:ratings].keys
    end
    if params[:sort]
      @flag=1
      @sort_by=params[:sort]
      session[:sort]=params[:sort]
    elsif session[:sort]
      @sort_by=session[:sort]
    end
    if @sort_by=='title'
      @css_title='hilite'
    elsif @sort_by=='release_date'
      @css_release_date='hilite'
    end
    if @flag==0 #no parameter passed
      if session[:ratings]||session[:sort] #redirect
        redirect_to movies_path(sort:session[:sort],ratings:session[:ratings])
      else #no parameter in session
        @movies=Movie.all
      end
    else
      @movies=Movie.with_ratings(@selected_ratings).order(@sort_by)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
