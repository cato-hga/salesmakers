AutoHtml.add_filter(:video_center) do |text|
  text.gsub(/http?s:\/\/training\.retaildoneright\.com.+(\?\S+)?/i) do |match|
    parts = match.partition '?'
    url = parts[0] + '/embed/' + parts[1] + parts[2]
    %|<iframe style="border:0px;padding:0px;margin:0px;" width="500" height="350" src="#{url}" frameborder="0" scrolling="no" allowfullscreen></iframe>|
  end
end