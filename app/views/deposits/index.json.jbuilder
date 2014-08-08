json.array!(@deposits) do |deposit|
  json.extract! deposit, :id, :user_id, :tender_id, :sum, :status
  json.url deposit_url(deposit, format: :json)
end
