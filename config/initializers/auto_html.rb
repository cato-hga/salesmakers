AutoHtml.add_filter(:video_center) do |text|
  text.gsub(/http?s:\/\/training\.retaildoneright\.com.+(\?\S+)?/i) do |match|
    parts = match.partition '/?'
    video_id = parts[0].rpartition '/'
    video_id = video_id.last
    access_token = parts.last
    src = "https://training.retaildoneright.com/usermedia/lifesizeplayer-1.3.swf?video_id=#{video_id}&embedded=true&#{access_token}&securestreaming=False"
    %|<object class="video_center_video">
      <param name="movie" value="#{src}">
      <param name="allowFullScreen" value="true">
      <param name="allowScriptAccess" value="always">
      <embed src="#{src}"
        type="application/x-shockwave-flash"
        allowfullscreen="true"
        allowscriptaccess="always">
     </object>|
    #%|<iframe style="border:0px;padding:0px;margin:0px;" width="500" height="350" src="#{url}" frameborder="0" scrolling="no" allowfullscreen></iframe>|
  end
end