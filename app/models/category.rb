class Category < ActiveRecord::Base
  has_many :youtube_categories
  has_many :nicovideo_categories
end
