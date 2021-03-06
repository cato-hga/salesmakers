# == Schema Information
#
# Table name: docusign_templates
#
#  id            :integer          not null, primary key
#  template_guid :string           not null
#  state         :string(2)        not null
#  document_type :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :integer          not null
#

class DocusignTemplate < ActiveRecord::Base
  enum document_type: [
           :nhp,
           :paf,
           :nos
       ]

  validates :template_guid, presence: true
  validates :state, length: { is: 2 }, inclusion: { in: ::UnitedStates }
  validates :document_type, presence: true, inclusion: { in: DocusignTemplate.document_types.keys }
  validates :project, presence: true

  belongs_to :project

  def self.send_nhp(candidate, advocate)
    location_area = candidate.location_area || return
    project = location_area.area.project || return
    state = candidate.state || return
    template = DocusignTemplate.find_by(state: state, project: project, document_type: DocusignTemplate.document_types[:nhp]) || return
    client = DocusignRest::Client.new
    created_envelope = client.create_envelope_from_template(
        status: 'created',
        email: {
            subject: "#{project.name} Employment Application and New Hire Paperwork for: #{candidate.name}",
            body: %{
              Enclosed are the documents that you must complete as the first stage of your potential employment with SalesMakers, Inc.  This is an electronic process.  Please complete as soon as possible.

              Tips for completing the New Hire Paperwork:
              ·         When completing the NHP you will need to create and electronic signature
              ·         You have 30 minutes to complete the NHP before it times out. If needed you can save your progress by selecting "finish later".
              ·         As you complete the NHP please use your legal name as stated on your work authorization document.
              ·         Click the "Next"" box on the left hand side in order to take you through the required fields, If anything is not applicable to you please type in "N/A".

              Please contact your recruiter should you have any questions or problems.

              Your location is set to #{location_area.location.address} (store number #{location_area.location.store_number}).
              Your area is set to #{location_area.area.name}.

            }
        },
        template_id: template.template_guid,
        signers: [
            {
                name: candidate.name,
                email: candidate.email,
                role_name: 'New Employee'
            }
        ]
    )
    return unless created_envelope['envelopeId']
    send_envelope(created_envelope['envelopeId'])
  end

  def self.send_third_party_nos(person, manager, remarks = '')
    project = person.person_areas.first.project
    template = DocusignTemplate.find_by template_guid: 'E0D92C92-D229-4C25-9CAF-E258FA990AF5' #Hard coding this temporarily
    client = DocusignRest::Client.new
    hash = {
        status: 'created',
        email: {
            subject: "#{project.name} - NOTICE OF SEPARATION FOR: #{person.display_name}"
        },
        template_id: template.template_guid,
        signers: [
            {
                name: manager.display_name,
                email: manager.email,
                role_name: 'Manager',
                text_tabs: [
                    {
                        label: 'Employee Name',
                        name: 'Employee Name',
                        value: "#{person.display_name}",
                        locked: true
                    },
                    {
                        label: 'Remarks',
                        name: 'Remarks',
                        value: "#{remarks}",
                        locked: false
                    }
                ]
            }
        ]
    }
    created_envelope = client.create_envelope_from_template(hash)
    return unless created_envelope['envelopeId']
    send_envelope(created_envelope['envelopeId'])
  end

  def self.send_ad_hoc_template template_guid, subject, signers
    client = DocusignRest::Client.new
    hash = {
        status: 'created',
        email: {
            subject: subject
        },
        template_id: template_guid,
        signers: signers
    }
    created_envelope = client.create_envelope_from_template(hash)
    return unless created_envelope['envelopeId']
    send_envelope(created_envelope['envelopeId'])
  end

  def self.send_nos(person, sender, last_day_worked, termination_date, separation_reason, rehire, retail, remarks)
    project = person.person_areas.first.project
    retail = retail == 'Retail' ? true : false
    template = DocusignTemplate.find_by(state: 'FL', project: project, document_type: DocusignTemplate.document_types[:nos]) || return
    client = DocusignRest::Client.new
    hash = {
        status: 'created',
        email: {
            subject: "#{project.name} - NOTICE OF SEPARATION FOR: #{person.display_name}"
        },
        template_id: template.template_guid,
        signers: [
            {
                name: sender.display_name,
                email: sender.email,
                role_name: 'Manager',
                text_tabs: [
                    {
                        label: 'Employee Name',
                        name: 'Employee Name',
                        value: "#{person.display_name}",
                        locked: true
                    },
                    {
                        label: "Last Day Worked",
                        name: "Last Day Worked",
                        value: "#{last_day_worked.strftime('%m-%d-%y')}",
                        locked: true
                    },
                    {
                        label: 'Termination Date',
                        name: 'Termination Date',
                        value: "#{termination_date.strftime('%m-%d-%y')}",
                        locked: true
                    },
                    {
                        label: 'Remarks',
                        name: 'Remarks',
                        value: "#{remarks}",
                        locked: true
                    },
                    {
                        label: 'Location',
                        name: 'Location',
                        value: retail,
                        locked: true
                    },
                    {
                        label: 'Eligible for Rehire',
                        name: 'Eligible for Rehire',
                        value: rehire,
                        locked: true
                    },
                    {
                        label: 'Separation Reason',
                        name: 'Separation Reason',
                        value: separation_reason.name,
                        locked: true
                    }
                ]
            }
        ]
    }
    created_envelope = client.create_envelope_from_template(hash)
    return unless created_envelope['envelopeId']
    send_envelope(created_envelope['envelopeId'])
  end

  def self.send_blank_nos(person, sender)
    project = person.person_areas.first.project
    template_guid = '7075D20E-8F1F-4383-8B07-5266539DD5AE'
    client = DocusignRest::Client.new
    hash = {
        status: 'created',
        email: {
            subject: "#{project.name} - NOTICE OF SEPARATION FOR: #{person.display_name} (#{person.email})"
        },
        template_id: template_guid,
        signers: [
            {
                name: sender.display_name,
                email: sender.email,
                role_name: 'Manager',
                text_tabs: [
                    {
                        label: 'Employee Name',
                        name: 'Employee Name',
                        value: "#{person.display_name}",
                        locked: true
                    }
                ]
            }
        ]
    }
    created_envelope = client.create_envelope_from_template(hash)
    return unless created_envelope['envelopeId']
    send_envelope(created_envelope['envelopeId'])
  end

  def self.send_blank_paf(person, sender)
    project = person.person_areas.first.project
    person_addresses = person.person_addresses
    state = person_addresses.empty? ? 'FL' : person_addresses.first.state
    template = DocusignTemplate.find_by(state: state, project: project, document_type: DocusignTemplate.document_types[:paf]) || return
    client = DocusignRest::Client.new
    hash = {
        status: 'created',
        email: {
            subject: "#{project.name} - PERSONNEL ACTION FORM FOR: #{person.display_name}"
        },
        template_id: template.template_guid,
        signers: [
            {
                name: sender.display_name,
                email: sender.email,
                role_name: 'Manager'
            }
        ]
    }
    created_envelope = client.create_envelope_from_template(hash)
    return unless created_envelope['envelopeId']
    send_envelope(created_envelope['envelopeId'])
  end

  def self.send_envelope(envelope_id)
    client = DocusignRest::Client.new
    content_type = { 'Content-Type' => 'application/json' }

    post_body = {
        "status" => "sent"
    }.to_json

    uri = client.build_uri("/accounts/#{client.acct_id}/envelopes/#{envelope_id}")
    http = client.initialize_net_http_ssl(uri)
    request = Net::HTTP::Put.new(uri.request_uri, client.headers(content_type))
    request.body = post_body
    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      envelope_id
    else
      nil
    end
  end
end
