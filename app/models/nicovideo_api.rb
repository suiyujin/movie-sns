require 'net/http'
require 'uri'
require 'json'

class NicovideoApi < ActiveRecord::Base
  def self.request(movie_id)
    WebApi.request(
      'http://ext.nicovideo.jp',
      '/api/getthumbinfo/',
      movie_id
    )
  end
end
