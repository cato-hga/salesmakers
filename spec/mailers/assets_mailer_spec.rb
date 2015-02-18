require 'rails_helper'

describe AssetsMailer do

  describe 'recoup_emailer' do
    let(:device) { create :device, line: line }
    let(:line) { create :line }
    let(:person) { create :person, personal_email: 'test@test.com' }
    let(:note) { 'Test' }
    let(:mail) { AssetsMailer.recoup_mailer(device, person, note) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Asset Returned')
    end
    it 'sends an email with the persons personal email (if they have one)' do
      expect(mail.to).to include(person.personal_email)
      expect(mail.to).to include('assets@retaildoneright.com')
      expect(mail.to.count).to eq(2)
    end

    it 'sends an email to just assets if there is no personal email on file' do
      person.personal_email = nil
      expect(mail.to).to include('assets@retaildoneright.com')
      expect(mail.to.count).to eq(1)
    end

    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('assetreturns@salesmakersinc.com')
    end

    it 'sends an email with the correct device info' do
      expect(mail.body.encoded).to include(device.serial)
      expect(mail.body.encoded).to include(line.identifier)
    end

    it 'handles no line being attached to a device' do
      device.line = nil
      expect(mail.body.encoded).to include('N/A')
    end
    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to include(person.name)
      expect(mail.body.encoded).to include(person.mobile_phone)
    end

    it 'handles not having a phone number for a person' do
      person.mobile_phone = nil
      expect(mail.body.encoded).to include('N/A')
    end

    it 'sends an email with the correct note' do
      expect(mail.body.encoded).to include(note)
    end
  end

  describe 'separated_with_assets_mailer' do
    let(:device) { create :device, line: line }
    let(:second_device) { create :device, serial: '12357799', identifier: '12357799' }
    let(:line) { create :line }
    let!(:first_person) { create :person, personal_email: 'test@test.com', device_deployments: [first_deployment] }
    let!(:second_person) { create :person,
                                  first_name: 'Second Test',
                                  last_name: 'User',
                                  personal_email: 'secondtest@test.com',
                                  devices: [device, second_device],
                                  device_deployments: [second_device_deployment, second_deployment]
    }
    let(:first_deployment) { create :device_deployment,
                                    device: device,
                                    #person: first_person,
                                    started: Date.today - 3.months,
                                    ended: Date.today - 2.months,
                                    tracking_number: '1234567890',
                                    comment: 'Test'
    }
    let(:second_deployment) { create :device_deployment,
                                     device: device,
                                     #person: second_person,
                                     started: Date.today - 1.month,
                                     tracking_number: '987654321'
    }
    let(:second_device_deployment) { create :device_deployment,
                                            device: second_device,
                                            #person: second_person,
                                            started: Date.today - 1.month,
                                            tracking_number: '528741963'
    }
    let(:mail) { AssetsMailer.separated_with_assets_mailer(second_person) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Separated Employee with Asset(s)')
    end

    it 'sends an email to Assets and IT' do
      expect(mail.to).to include('assets@retaildoneright.com')
      expect(mail.to).to include('it@retaildoneright.com')
    end

    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('assetreturns@salesmakersinc.com')
    end


    it 'sends an email with the correct device info' do
      expect(mail.body.encoded).to include(device.serial)
      expect(mail.body.encoded).to include(line.identifier)
      expect(mail.body.encoded).to include(second_device.serial)
    end

    it 'handles no line being attached to a device' do
      device.line = nil
      expect(mail.body.encoded).to include('N/A')
    end

    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to include(first_person.display_name)
      expect(mail.body.encoded).to include(first_person.mobile_phone)
      expect(mail.body.encoded).to include(first_person.personal_email)
    end

    it 'handles not having a phone number for a person' do
      first_person.mobile_phone = nil
      expect(mail.body.encoded).to include('N/A')
    end

    it 'handles multiple assets for a user' do
      expect(mail.body.encoded).to include('Asset 2')
      expect(mail.body.encoded).to include(second_device.serial)
    end
    it 'contains the deployment history for a device' do
      expect(mail.body.encoded).to include(second_person.display_name)
      expect(mail.body.encoded).to include((Date.today - 3.months).strftime('%m/%d/%Y'))
      expect(mail.body.encoded).to include((Date.today - 2.months).strftime('%m/%d/%Y'))
      expect(mail.body.encoded).to include((Date.today - 1.month).strftime('%m/%d/%Y'))
      expect(mail.body.encoded).to include(first_deployment.tracking_number)
      expect(mail.body.encoded).to include(second_deployment.tracking_number)
      expect(mail.body.encoded).to include(first_deployment.comment)
    end
  end

  describe 'separated_without_assets_mailer' do
    let!(:person) { create :person, personal_email: 'test@test.com' }
    let(:mail) { AssetsMailer.separated_without_assets_mailer(person) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Separated Employee without Asset')
    end

    it 'sends an email to Assets and IT' do
      expect(mail.to).to include('assets@retaildoneright.com')
      expect(mail.to).to include('it@retaildoneright.com')
    end

    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('assetreturns@salesmakersinc.com')
    end


    it 'sends an email with the correct info' do
      expect(mail.body.encoded).to include('has just been separated from the company and does not have any assets in their possession.')
    end

    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to include(person.display_name)
      expect(mail.body.encoded).to include(person.mobile_phone)
      expect(mail.body.encoded).to include(person.personal_email)
    end

    it 'handles not having a phone number for a person' do
      person.mobile_phone = nil
      expect(mail.body.encoded).to include('N/A')
    end
  end

  describe 'asset return mailer' do
    let(:device) { create :device, line: line }
    let(:second_device) { create :device, serial: '12357799', identifier: '12357799' }
    let(:line) { create :line }
    let!(:person) { create :person, personal_email: 'test@test.com', devices: [device, second_device] }
    let(:mail) { AssetsMailer.asset_return_mailer(person) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Asset Return Instructions')
    end

    it 'sends an email to Assets and IT' do
      expect(mail.to).to include('assets@retaildoneright.com')
      expect(mail.to).to include(person.personal_email)
    end


    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('assetreturns@salesmakersinc.com')
    end

    it 'sends an email with the correct device info' do
      expect(mail.body.encoded).to include(device.serial)
      expect(mail.body.encoded).to include(line.identifier)
      expect(mail.body.encoded).to include(second_device.serial)
    end

    it 'handles no line being attached to a device' do
      device.line = nil
      expect(mail.body.encoded).to include('N/A')
    end

    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to include(person.display_name)
    end

    it 'handles not having a phone number for a person' do
      person.mobile_phone = nil
      expect(mail.body.encoded).to include('N/A')
    end

    it 'handles multiple assets for a user' do
      expect(mail.body.encoded).to include(second_device.serial)
    end
  end

  describe 'lost/stolen mailer' do
    let(:device) { create :device, line: line }
    let(:line) { create :line }
    let!(:person) { create :person, personal_email: 'test@test.com', devices: [device] }
    let(:mail) { AssetsMailer.lost_or_stolen_mailer(device) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Deployed Asset Marked as Lost or Stolen')
    end

    it 'sends an email to Assets' do
      expect(mail.to).to include('assets@retaildoneright.com')
    end

    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('assetreturns@salesmakersinc.com')
    end


    it 'sends an email with the correct device info' do
      expect(mail.body.encoded).to include(device.serial)
      expect(mail.body.encoded).to include(line.identifier)
    end

    it 'handles no line being attached to a device' do
      device.line = nil
      expect(mail.body.encoded).to include('N/A')
    end

    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to include(person.display_name)
      expect(mail.body.encoded).to include(person.mobile_phone)
      expect(mail.body.encoded).to include(person.personal_email)
    end

    it 'handles not having a phone number for a person' do
      person.mobile_phone = nil
      expect(mail.body.encoded).to include('N/A')
    end
  end

  describe 'found mailer' do
    let(:device) { create :device, line: line }
    let(:line) { create :line }
    let!(:person) { create :person, personal_email: 'test@test.com', devices: [device] }
    let(:mail) { AssetsMailer.found_mailer(device) }

    it 'sends an email with correct subject' do
      expect(mail.subject).to include('Lost or Stolen Asset Marked as Found')
    end

    it 'sends an email to Assets' do
      expect(mail.to).to include('assets@retaildoneright.com')
    end

    it 'sends an email with the correct "from" email' do
      expect(mail.from).to include('assetreturns@salesmakersinc.com')
    end


    it 'sends an email with the correct device info' do
      expect(mail.body.encoded).to include(device.serial)
      expect(mail.body.encoded).to include(line.identifier)
    end

    it 'handles no line being attached to a device' do
      device.line = nil
      expect(mail.body.encoded).to include('N/A')
    end

    it 'sends an email with the correct person info' do
      expect(mail.body.encoded).to include(person.display_name)
      expect(mail.body.encoded).to include(person.mobile_phone)
      expect(mail.body.encoded).to include(person.personal_email)
    end

    it 'handles not having a phone number for a person' do
      person.mobile_phone = nil
      expect(mail.body.encoded).to include('N/A')
    end
  end
end