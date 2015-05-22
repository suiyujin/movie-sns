class Movie < ActiveRecord::Base
  has_many :relations1, class_name: 'Relation', foreign_key: 'movie1_id'
  has_many :relations2, class_name: 'Relation', foreign_key: 'movie2_id'
  acts_as_taggable
end
