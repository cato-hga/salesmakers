class GroupMeEmojiFilter
  def self.filter(text, attachments)
    if attachments and attachments.count > 0 and GroupMePowerUps.count > 0
      for attachment in attachments do
        if attachment['type'] and attachment['type'] == 'emoji'
          pack_id = attachment['charmap'][0][0]
          powerup_id = attachment['charmap'][0][1]
          powerup_pack = GroupMePowerUps.find { |pack| pack['meta']['pack_id'] == pack_id }
          next unless powerup_pack
          inline = powerup_pack['meta']['inline'].find { |inline| inline['x'] == 20 }
          next unless inline
          image = inline['image_url']
          pixel_down = 20 * powerup_id * -1
          image_html = '<span style="'
          image_html += "background: url(#{image}) no-repeat left top;"
          image_html += "background-size: 20px auto !important;"
          image_html += "background-position: 0 #{pixel_down}px;"
          image_html += '" class="emoji"></span>'
          text.gsub! attachment['placeholder'], image_html
        end
      end
    end
    text
  end
end