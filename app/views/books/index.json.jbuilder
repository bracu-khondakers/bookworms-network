json.array!(@books) do |book|
  json.extract! book, :id, :user_id, :isbn, :title, :genre, :availability, :condition, :market_price, :publisher_id
  json.url book_url(book, format: :json)
end
