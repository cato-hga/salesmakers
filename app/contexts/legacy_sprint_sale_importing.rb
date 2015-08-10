class LegacySprintSaleImporting
  def execute
    script_filename = Rails.root.join('lib', 'etl', 'connect_sprint_sales_import.etl').to_s
    etl_script = IO.read(script_filename)
    job = Kiba.parse etl_script, script_filename
    Kiba.run job
  end
end
