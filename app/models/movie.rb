class Movie < ActiveRecord::Base
  has_many :relations1, class_name: 'Relation', foreign_key: 'movie1_id', dependent: :destroy
  has_many :relations2, class_name: 'Relation', foreign_key: 'movie2_id', dependent: :destroy
  belongs_to :category
  belongs_to :user
  acts_as_taggable
end
