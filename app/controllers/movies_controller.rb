class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: :create

  respond_to :html

  def search
    @movie = Movie.new(movie_search_params)
    keywords = @movie.keywords

    # urlのみの場合はその動画があるか調べる
    if keywords.blank? || keywords =~ /^\s+$/
      results = ''
    elsif keywords =~ /^(http:|https:)\/\/[^\s]+$/
      results = [Movie.find_by(url: keywords)]
    elsif
      query = keywords.split(' ').map { |keyword| "title like '%#{keyword}%'" }
      results = Movie.where(query.join(' AND '))
    end

    res = make_response(results)

    render json: res
  end

  def make_response(results)
    # 関連があれば、関連先の動画を追加
    results.each do |result|
      result.relations1.each do |relation1|
        unless results.find { |result| result.id == relation1.movie2_id }
          results.push(Movie.find(relation1.movie2_id))
        end
      end
    end

    # Json整形
    movies = results.map do |result|
      {
        id: result.id,
        title: result.title,
        description: result.description,
        url: result.url,
        thumbnail_url: result.thumbnail_url,
        thumbnail_path: result.thumbnail_path,
        category_name: result.category.name,
        user_name: result.user.name
      }
    end

    relations_by_movies = Array.new
    results.each do |result|
      relations_by_movies << result.relations1.map do |relation|
        {
          relation: relation,
          comments: relation.comments
        }
      end
    end

    relations = Array.new
    relations_by_movies.each do |relations_by_movie|
      relations_by_movie.each do |relation_by_movie|
        relations << {
          id: relation_by_movie[:relation].id,
          similarity: relation_by_movie[:relation].similarity,
          movie1_id: relation_by_movie[:relation].movie1_id,
          movie2_id: relation_by_movie[:relation].movie2_id,
          user_name: relation_by_movie[:relation].user.name,
          comments: relation_by_movie[:comments]
        }
      end
    end

    if results.blank?
      res = {
        result: false,
        data: nil
      }
    else
      res = {
        result: true,
        data: {
          movies: movies,
          relations: relations
        }
      }
    end
    res
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

    @movie.user_id = current_user.id

    # APIを叩いて情報取得
    if @movie.url.include?('youtube')
      movie_id = @movie.url.match(/https:\/\/www.youtube.com\/watch\?v=(\w+)$/)[1]
      response = YoutubeApi.request_ssl(movie_id)

      title = response["items"][0]["snippet"]["title"]
      description = response["items"][0]["snippet"]["description"]
      thumbnail_url = response["items"][0]["snippet"]["thumbnails"]["medium"]["url"]
      youtube_category_id = response["items"][0]["snippet"]["categoryId"]

      category_id = YoutubeCategory.find_by(youtube_category_id: youtube_category_id).category_id

    else @movie.url.include?('nicovideo')
      movie_id = @movie.url.match(/http:\/\/www.nicovideo.jp\/watch\/(\w+)/)[1]
      response = NicovideoApi.request(movie_id)

      title = response["nicovideo_thumb_response"]["thumb"]["title"]["__content__"]
      description = response["nicovideo_thumb_response"]["thumb"]["description"]["__content__"]
      category_name = ''
      tags = response["nicovideo_thumb_response"]["thumb"]["tags"]["tag"].map do |tag|
        category_name = tag["__content__"] if tag["category"]
        tag["__content__"]
      end

      thumbnail_url = response["nicovideo_thumb_response"]["thumb"]["thumbnail_url"]["__content__"]
      category_id = NicovideoCategory.find_by(name: category_name).category_id
    end

    @movie.movie_id = movie_id
    @movie.title = title
    @movie.description = description
    @movie.thumbnail_url = thumbnail_url
    @movie.category_id = category_id

    @movie.save

    # 関連をCreate
    source_id = @movie.source_id
    Relation.create(movie1_id: source_id, movie2_id: @movie.id, user_id: current_user.id)

    res = make_response([@movie])

    render json: res
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
      params.require(:movie).permit(:movie_id, :title, :description, :url, :thumbnail_url, :thumbnail_path, :source_id)
    end

    def movie_search_params
      params.require(:movie).permit(:keywords)
    end
end
