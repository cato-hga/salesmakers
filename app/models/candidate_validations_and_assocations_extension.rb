module CandidateValidationsAndAssocationsExtension
  def self.included(klass)
    klass.extend ClassMethods
  end

  def proper_casing
    self.first_name = NameCase(self.first_name) if self.first_name
    self.last_name = NameCase(self.last_name) if self.last_name
    self.email = self.email.downcase if self.email
  end

  def trim_names
    first_name.strip! if first_name
    last_name.strip! if last_name
  end

  module ClassMethods
    def attribute_validations
      validates :first_name, presence: true, length: { minimum: 2 }
      validates :last_name, presence: true, length: { minimum: 2 }
      validate :strip_phone_number
      validates :mobile_phone, uniqueness: true
      validates :mobile_phone, length: { is: 10 },
                if: Proc.new { |c| c.new_record? }
      validates :email,
                presence: true,
                format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' },
                uniqueness: { case_sensitive: false }
      validates :zip, length: { is: 5 }
      validates :candidate_source_id, presence: true
      validates :created_by, presence: true

      before_validation :trim_names
      after_validation :proper_casing
    end

    def belongs_to_associations
      belongs_to :location_area
      belongs_to :person
      belongs_to :candidate_source
      belongs_to :candidate_denial_reason
      belongs_to :created_by, class_name: 'Person', foreign_key: 'created_by'
      belongs_to :sprint_radio_shack_training_session
      belongs_to :potential_area, class_name: 'Area', foreign_key: 'potential_area_id'
    end

    def has_one_associations
      has_one :candidate_availability
      has_one :training_availability
      has_one :sprint_pre_training_welcome_call
      has_one :candidate_drug_test
    end

    def has_many_associations
      has_many :prescreen_answers
      has_many :interview_schedules
      has_many :interview_answers
      has_many :job_offer_details
      has_many :candidate_contacts
    end

    def setup_assocations
      belongs_to_associations
      has_one_associations
      has_many_associations
    end
  end
end