json.array! @reminders do |reminder|
  json.extract! reminder, :id, :recurrence, :day, :user_id, :content, :time, :date, :jstime, :web_notification, :phone_notification
end
