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
