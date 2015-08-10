powerups_url = "https://powerup.groupme.com/powerups"
unless Rails.env.test?
  response = HTTParty.get(powerups_url)
  if response.success?
    ::GroupMePowerUps = response['powerups']
  else
    ::GroupMePowerUps = Array.new
  end
else
  ::GroupMePowerUps = Array.new
end