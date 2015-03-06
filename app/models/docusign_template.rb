class DocusignTemplate < ActiveRecord::Base
  enum document_type: [
           :nhp,
           :paf,
           :nos
       ]

  states = Array["AK", "AL", "AR", "AS", "AZ", "CA", "CO",
                 "CT", "DC", "DE", "FL", "GA", "GU", "HI",
                 "IA", "ID", "IL", "IN", "KS", "KY", "LA",
                 "MA", "MD", "ME", "MI", "MN", "MO", "MS",
                 "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                 "NV", "NY", "OH", "OK", "OR", "PA", "PR",
                 "RI", "SC", "SD", "TN", "TX", "UT", "VA",
                 "VI", "VT", "WA", "WI", "WV", "WY"]

  validates :template_guid, presence: true
  validates :state, length: { is: 2 }, inclusion: { in: states }
  validates :document_type, presence: true, inclusion: { in: DocusignTemplate.document_types.keys }
  validates :project, presence: true

  belongs_to :project
end
