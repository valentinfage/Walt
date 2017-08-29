json.array! @reminders do |reminder|
  json.extract! reminder, :id, :recurrence, :date, :user_id, :content, :time, :jstime
end
