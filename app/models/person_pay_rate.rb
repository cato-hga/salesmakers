class PersonPayRate < ActiveRecord::Base
  validates :person, presence: true
  validates :wage_type, presence: true
  validates :rate, presence: true, numericality: { greater_than: 7.50 }
  validates :effective_date, presence: true

  belongs_to :person

  default_scope { order effective_date: :desc }

  enum wage_type: [
           :hourly,
           :salary
       ]

  def self.update_from_connect minutes
    cbpscs = ConnectBusinessPartnerSalaryCategory.where "updated >= ?", (Time.now - minutes.minutes).apply_eastern_offset
    for cbpsc in cbpscs do
      connect_user = ConnectUser.find_by c_bpartner_id: cbpsc.c_bpartner_id || next
      person = Person.return_from_connect_user connect_user || next
      person_pay_rate = get_or_create cbpsc
      person_pay_rate.person = person
      person_pay_rate.wage_type = get_wage_type cbpsc || next
      person_pay_rate.rate = get_rate cbpsc || next
      person_pay_rate.effective_date = get_effective_date cbpsc || next
      person_pay_rate.connect_business_partner_salary_category_id = cbpsc.c_bp_salcategory_id
      person_pay_rate.save
    end
    ProcessLog.create process_class: "PersonPayRate", records_processed: cbpscs.count, notes: "update_from_connect(#{minutes.to_s})"
  end

  def self.get_or_create cbpsc
    existing = PersonPayRate.find_by connect_business_partner_salary_category_id: cbpsc.c_bp_salcategory_id
    return existing if existing
    PersonPayRate.new
  end

  def self.get_wage_type cbpsc
    sc = cbpsc.connect_salary_category || return
    sc.name.include?('hr') ? :hourly : :salary
  end

  def self.get_rate cbpsc
    sc = cbpsc.connect_salary_category || return
    name = sc.name
    name = name.
        gsub('hr.', '').
        gsub('yr.', '').
        gsub(/[^\d\.]/, '')
    name.nan? ? nil : name.to_f
  end

  def self.get_effective_date cbpsc
    cbpsc.datefrom.remove_eastern_offset.to_date
  end
end