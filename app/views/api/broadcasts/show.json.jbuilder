#json.extract! @broadcast, :content, :user_id, :created_at
json.partial! "api/broadcasts/broadcast", user: @broadcast
