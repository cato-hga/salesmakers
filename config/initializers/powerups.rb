unless Rails.env.test?
  powerups_url = "https://powerup.groupme.com/powerups"
  response = HTTParty.get(powerups_url)
  if response.success?
    ::GroupMePowerUps = response['powerups']
  else
    ::GroupMePowerUps = Array.new
  end
end