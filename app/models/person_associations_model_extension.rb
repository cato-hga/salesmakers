module PersonAssociationsModelExtension
  def setup_associations
    setup_belongs_to
    setup_has_one
    setup_has_many
    setup_has_many_through
    setup_complex_associations
  end

  def setup_belongs_to
    belongs_to_associations = [
        :position, :connect_user
    ]

    belongs_to :supervisor, class_name: 'Person'
    for belongs_to_association in belongs_to_associations do
      belongs_to belongs_to_association
    end
  end

  def setup_has_one
    has_one :group_me_user
    has_one :candidate
    has_one :screening
  end

  def setup_has_many
    has_many_associations = [
        :person_areas, :device_deployments, :devices, :communication_log_entries, :group_me_posts,
        :employments, :person_addresses, :vonage_sale_payouts, :vonage_sales,
        :vonage_refunds, :vonage_paycheck_negative_balances, :sprint_sales,
        :candidate_notes, :comcast_customer_notes, :directv_customer_notes,
        :shifts, :person_pay_rates, :person_client_areas, :person_punches
    ]

    for has_many_association in has_many_associations do
      has_many has_many_association
    end
  end

  def setup_has_many_through
    has_many :permissions, through: :position
    has_many :areas, through: :person_areas
    has_many :candidate_contacts, through: :candidate
  end

  def setup_complex_associations
    has_many :day_sales_counts, as: :saleable
    has_many :sales_performance_ranks, as: :rankable
    has_many :employees, class_name: 'Person', foreign_key: 'supervisor_id'
    has_many :to_sms_messages, class_name: 'SMSMessage', foreign_key: 'to_person_id'
    has_many :from_sms_messages, class_name: 'SMSMessage', foreign_key: 'from_person_id'
  end
end