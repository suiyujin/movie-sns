class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def search
    @movie = Movie.new( movie_search_params )
    keywords = @movie.keywords

    # urlのみの場合はその動画があるか調べる
    if keywords.blank? || keywords =~ /^\s+$/
      result = ''
    elsif keywords =~ /^http:\/\/[^\s]+$/
      result = Movie.find_by(url: keywords)
    elsif
      query = keywords.split(' ').map { |keyword| "title like '%#{keyword}%'" }
      result = Movie.where(query.join(' AND '))
    end

    if result.blank?
      res = {
        result: false,
        data: nil
      }
    else
      res = {
        result: true,
        data: result
      }
    end
    render json: res
  end

  def index
    @movie = Movie.new
  end

  def show
    respond_with(@movie)
  end

  def new
    @movie = Movie.new
    respond_with(@movie)
  end

  def edit
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.save
    respond_with(@movie)
  end

  def update
    @movie.update(movie_params)
    respond_with(@movie)
  end

  def destroy
    @movie.destroy
    respond_with(@movie)
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:movie_id, :title, :description, :url, :thumbnail_url, :thumbnail_path)
    end

    def movie_search_params
      params.require(:movie).permit(:keywords)
    end
end
