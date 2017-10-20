json.array! @emails do |email|
  json.extract! email, :id, :user_id, :content, :receiver, :object
end
