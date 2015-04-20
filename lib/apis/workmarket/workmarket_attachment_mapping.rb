class WorkmarketAttachmentMapping
  include Kartograph::DSL

  kartograph do
    mapping WorkmarketAttachment

    scoped :read do
      property :filename, key: 'name'
      property :url, key: 'relative_uri'
    end
  end
end