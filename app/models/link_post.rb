require 'open-uri'

class LinkPost < ActiveRecord::Base
  dragonfly_accessor :image do
    copy_to(:thumbnail) { |a| a.thumb('200x200#nw') }
    copy_to(:preview) { |a| a.thumb('500x300#nw') }
    copy_to(:large) { |a| a.thumb('750x500#nw') }
  end
  dragonfly_accessor :thumbnail
  dragonfly_accessor :preview
  dragonfly_accessor :large

  include UploadableMedia
  include Publishable
  include PersonVisibility

  belongs_to :person

  # Generate the thumbnail on validate so we can return errors on failure
  validate :generate_thumbnail_from_url
  validate :save_page_title

  # Cleanup temp files when we are done
  after_save :cleanup_temp_thumbnail

  # Generate a thumbnail from the remote URL
  def generate_thumbnail_from_url

    # Skip thumbnail generation if:
    # a) there are already other validation errors
    # b) an image was manually specified
    # c) an image is already stored and the URL hasn't changed
    skip_generate = self.errors.any? || (self.image_changed? ||
        (self.image_stored? && !self.url_changed?))
    # p "*** generating thumbnail: #{!skip_generate}"
    return if skip_generate

    # Generate and assign an image or set a validation error
    begin
      tempfile = temp_thumbnail_path
      cmd = "wkhtmltoimage --disable-plugins --quality 95 \"#{self.url}\" \"#{tempfile}\""
      # p "*** grabbing thumbnail: #{cmd}"
      system(cmd) # sometimes returns false even if image was saved
      self.image = File.new(tempfile) # will throw if not saved
    rescue => e
      # p "*** thumbnail error: #{e}"
      self.errors.add(:base, "Cannot generate thumbnail. Is your URL valid?")
    ensure
    end
  end

  def save_page_title
    skip_generate = self.errors.any? || !self.url_changed?
    return if skip_generate
    encode_content(open(self.url).read) =~ /<title>(.*?)<\/title>/
    begin
      self.title = $1
    rescue => e
      self.errors.add(:base, "Cannot find page title. Is your link valid?")
    ensure
    end
  end

  # Return the absolute path to the temporary thumbnail file
  def temp_thumbnail_path
    File.expand_path("#{self.url.parameterize.slice(0, 20)}.jpg", Dragonfly.app.datastore.root_path)
  end

  # Cleanup the temporary thumbnail image
  def cleanup_temp_thumbnail
    File.delete(temp_thumbnail_path) rescue 0
  end

  def self.linkify(link)
    new_link = link
    if unrecognized_protocol?(new_link)
      new_link = strip_protocol(new_link)
      return 'http://' + new_link
    end
    new_link = 'http://' + new_link unless slash_slash_index(new_link)
    new_link
  end

  def self.slash_slash_index(link)
    link.index('//')
  end

  def self.strip_protocol(link)
    link_length = link.length
    link[(slash_slash_index(link) + 2)..link_length]
  end

  def self.unrecognized_protocol?(link)
    slash_slash_index(link) and not (link.starts_with?('http://') or
        link.starts_with?('https://'))
  end

  private

    def encode_content(content)
      content.encode 'UTF-8',
                     invalid: :replace,
                     undef: :replace,
                     replace: ''
    end
end
