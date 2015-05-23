require 'net/http'
require 'uri'
require 'json'

class YoutubeApi < ActiveRecord::Base
  def self.request_ssl(movie_id)
    WebApi.request_ssl(
      'https://www.googleapis.com',
      '/youtube/v3/videos',
      {
        part: 'snippet',
        hl: 'ja',
        key: ENV['YOUTUBE_API_KEY'],
        id: movie_id
      }
    )
  end
end
