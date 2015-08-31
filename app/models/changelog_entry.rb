# == Schema Information
#
# Table name: changelog_entries
#
#  id            :integer          not null, primary key
#  department_id :integer
#  project_id    :integer
#  all_hq        :boolean
#  all_field     :boolean
#  heading       :string           not null
#  description   :text             not null
#  released      :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ChangelogEntry < ActiveRecord::Base
  validates :heading, length: { minimum: 5 }
  validates :description, length: { minimum: 20 }
  validates :released, presence: true
  validate :department_selection
  validate :project_selection

  belongs_to :project
  belongs_to :department

  default_scope { order(released: :desc) }

  strip_attributes

  scope :visible, ->(person = nil) {
    return ChangelogEntry.none unless person
    entries = ChangelogEntry.where("department_id IS NULL " +
                                                   "AND project_id IS NULL " +
                                                   "AND (all_hq = false " +
                                                   "OR all_hq IS NULL) " +
                                                   "AND (all_field = false " +
                                                   "OR all_field IS NULL)")
    entries = entries + ChangelogEntry.where(all_hq: true) if person.hq?
    entries = entries + ChangelogEntry.where(all_field: true) if person.field?
    entries = entries + ChangelogEntry.where(project: person.projects)
    entries = entries + ChangelogEntry.where(department: person.position.department) if person.position
    return ChangelogEntry.none if entries.empty?
    ChangelogEntry.where("id IN (#{entries.map(&:id).join(',')})")
  }

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
