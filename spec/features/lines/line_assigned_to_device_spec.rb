  require 'rails_helper'

  describe 'Adding a Line to a Device' do
    let(:it_tech) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    let(:line) {create :line, line_states:[line_state]}
    let(:line_state) {create :line_state, name: 'Active'}

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
    end

    describe 'The Show Page' do
      it 'should show an assign device button for an active line without a device' do
        visit line_path(line)
        expect(page).to have_link('Assign Line to Device')
      end

      it 'should direct to line edit devices page' do
        visit line_path(line)
        click_on 'Assign Line to Device'
        expect(page.current_path).to eq line_edit_devices_path(line)
      end

    end
      context 'Line with a Device Attached' do
        let(:line_with_device) { create :line, device: device}
        let(:device) {create :device}
        it 'should not show an assign device button' do
          visit line_path(line_with_device)
          expect(page).not_to have_link('Assign Line to Device')
        end
      end

        describe 'The Line Edit Page' do
          before(:each) do
            visit line_edit_devices_path(line)
          end
          it 'should show the specific line number' do

          end
          it 'should display devices without a line attached' do

          end
          it 'should have an assign line button ' do

          end
        end
  end