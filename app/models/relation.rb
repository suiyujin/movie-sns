class Relation < ActiveRecord::Base
  belongs_to :movie1, class_name: 'Movie', foreign_key: 'movie1_id'
  belongs_to :movie2, class_name: 'Movie', foreign_key: 'movie2_id'
  belongs_to :user

  # すでにDBに存在する組み合わせは登録しない
  validates :movie1_id, uniqueness: { scope: :movie2_id }
  # 逆にした組み合わせがすでに存在する場合も登録したくない

  # 同じmovie_idの組み合わせは登録したくない

end
