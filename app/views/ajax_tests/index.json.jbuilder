json.array!(@ajax_tests) do |ajax_test|
  json.extract! ajax_test, :id, :movie_id, :title, :description, :url, :thumbnail_url, :thumbnail_path, :user_id_id
  json.url ajax_test_url(ajax_test, format: :json)
end
