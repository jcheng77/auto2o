json.array!(@devices) do |device|
  json.extract! device, :id, :push_id, :type, :state
  json.url device_url(device, format: :json)
end
