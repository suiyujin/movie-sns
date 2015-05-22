json.array!(@relations) do |relation|
  json.extract! relation, :id, :good_count, :bad_count, :similarity, :movie_id, :movie_id, :user_id
  json.url relation_url(relation, format: :json)
end
