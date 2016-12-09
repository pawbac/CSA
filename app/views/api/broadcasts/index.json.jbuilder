json.array!(@broadcasts) do |broadcast|
  json.created_at broadcast.created_at.to_s(:long)
  json.feeds broadcast.feeds.each do |feed|
    json.name feed.name.humanize
  end
  json.extract! broadcast, :content, :user
  json.url broadcast_url(broadcast, format: :json)
end
