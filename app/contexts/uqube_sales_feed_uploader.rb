class UQubeSalesFeedUploader
  def self.upload
    script_filename = Rails.root.join('lib', 'etl', 'uqube_sales_feed_uploader.etl').to_s
    etl_script = IO.read(script_filename)
    job = Kiba.parse etl_script, script_filename
    Kiba.run job
  end
end