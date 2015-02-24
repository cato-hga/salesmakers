class ChangelogEntry < ActiveRecord::Base
  validates :heading, length: { minimum: 5 }
  validates :description, length: { minimum: 20 }
  validates :released, presence: true
  validate :department_selection
  validate :project_selection

  belongs_to :project
  belongs_to :department

  private

  def department_selection
    cannot_be_chosen(:department_id, [:project_id, :all_hq, :all_field])
  end

  def project_selection
    cannot_be_chosen(:project_id, [:department_id, :all_hq, :all_field])
  end

  def cannot_be_chosen(what_is_chosen, cannot_be_chosen)
    return unless self[what_is_chosen]
    attr_name = self.class.human_attribute_name(what_is_chosen)
    for choice in cannot_be_chosen do
      next unless self[choice]
      errors.add(choice, "cannot be chosen if #{attr_name} is chosen")
    end
  end
end
