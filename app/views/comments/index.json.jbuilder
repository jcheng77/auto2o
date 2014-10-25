json.array!(@comments) do |comment|
  json.extract! comment, :id, :shop_id, :dealer_id, :content, :rate
  json.url comment_url(comment, format: :json)
end
