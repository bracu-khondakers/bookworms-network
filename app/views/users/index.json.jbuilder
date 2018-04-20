json.array!(@users) do |user|
  json.extract! user, :id, :username, :password, :name, :birth_date, :about_me
  json.url user_url(user, format: :json)
end
