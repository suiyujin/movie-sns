json.array!(@movies) do |movie|
  json.extract! movie, :id, :movie_id, :title, :description, :url, :thumbnail_url, :thumbnail_path
  json.url movie_url(movie, format: :json)
end
