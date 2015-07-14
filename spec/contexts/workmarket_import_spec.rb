require 'rails_helper'

describe WorkmarketImport do
  let!(:import) { described_class.new }
  let!(:project) { create :project, workmarket_project_num: '10005' }

  it 'sets locations', vcr: { record: :once } do
    expect(import).to receive(:set_locations)
    import.execute
  end

  it 'filters the locations to only unsaved', vcr: { record: :once } do
    expect(import).to receive(:filter_to_new_locations)
    import.execute
  end


  it 'saves locations', vcr: { record: :once } do
    expect {
      import.execute
    }.to change(WorkmarketLocation, :count).by_at_least(1)
  end

  it 'sets completed assignments', vcr: { record: :once } do
    expect(import).to receive(:set_completed_assignments)
    import.execute
  end

  it 'deletes the assignments before importing', vcr: { record: :once } do
    expect(import).to receive(:delete_previously_stored_assignments)
    import.execute
  end

  # it 'saves assignments', :vcr do
  #   expect {
  #     import.execute
  #   }.to change(WorkmarketAssignment, :count).by_at_least(1)
  # end
  #
  # it 'saves attachments', :vcr do
  #   expect {
  #     import.execute
  #   }.to change(WorkmarketAttachment, :count).by_at_least(1)
  # end
  #
  # it 'saves the attachments', :vcr do
  #   import.execute
  #   expect(File.exist?('public/uploads/020986f0-4aca-4af3-bc50-af58d921e9ab/image.jpg')).to be_truthy
  # end
  #
  # it 'saves custom fields', :vcr do
  #   expect {
  #     import.execute
  #   }.to change(WorkmarketField, :count).by_at_least(1)
  # end
end