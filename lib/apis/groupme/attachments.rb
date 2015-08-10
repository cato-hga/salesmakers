module Groupme
  module Attachments
    def get_images(max = 10, filter_messages_per_group = 10)
      messages = get_recent_messages filter_messages_per_group
      urls = Array.new
      for message in messages do
        attachments = message.attachments
        for attachment in attachments do
          urls << attachment['url'] if attachment['type'] == 'image'
        end
        return urls[0..(max - 1)] if urls.count >= max
      end
      urls
    end

    def back_up_images(group_id, group_name)
      messages = get_messages_before group_id, group_name
      return if messages.nil?
      until messages.count == 0
        urls = get_urls_from_messages(messages)
        download_url_batch(urls, group_name)
        messages = get_messages_before group_id, group_name, messages.last.message_id
        return if messages.nil?
      end
    end

    def get_urls_from_messages(messages)
      urls = []
      for message in messages do
        url = message.image_url
        urls << url if url
      end
      urls
    end

    def download_url_batch(urls, group_name)
      return unless urls
      for url in urls do
        next if url.include?("text.rbdconnect.com") or url.include?("salesmakersinc.com")
        puts "Downloading #{url}"
        download_and_save_image(group_name_to_directory_name(group_name), url)
      end
    end

    def group_name_to_directory_name(group_name)
      encoding_options = {
          :invalid => :replace, # Replace invalid byte sequences
          :undef => :replace, # Replace anything not defined in ASCII
          :replace => '' # Use a blank for those replacements
      }
      group_name.encode(Encoding.find('ASCII'), encoding_options)
    end

    def download_and_save_image(directory, url)
      begin
        dir_string = "/tmp/GroupMe Image Backup/#{directory}"
        FileUtils.mkdir_p(dir_string)
        filename = get_filename_from_url url
        write_to_file dir_string, filename, url
      rescue
        return
      end
    end

    private

    def get_filename_from_url url
      filename = File.basename(URI.parse(url).path)
      parts = filename.split '.'
      parts.insert(parts.length - 2)
      parts.insert(parts.length - 2, parts.delete_at(parts.length - 1)).
          join('.')
    end

    def write_to_file dir_string, filename, url
      open("#{dir_string}/#{filename}", 'wb') do |file|
        open(url) do |uri|
          file.write uri.read
        end
      end
    end
  end
end