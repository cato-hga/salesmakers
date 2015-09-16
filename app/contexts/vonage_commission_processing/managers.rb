module Managers

  private

  def change_manager_payouts
    determine_vonage_managers
    change_vonage_manager_payout_amounts
    self
  end

  def determine_vonage_managers
    @vonage_managers = []
    projects = [Project.find_by(name: 'Vonage'), Project.find_by(name: 'Vonage Events')]
    for project in projects do
      for area in project.areas do
        management_person_areas = area.person_areas.where(manages: true)
        @vonage_managers += management_person_areas.map(&:person)
      end
    end
    @vonage_managers = @vonage_managers.flatten.compact
    self
  end

  def change_vonage_manager_payout_amounts
    return unless @all_payouts and @vonage_managers
    for payout in @all_payouts do
      change_payout_amount_for_manager(payout) if @vonage_managers.include?(payout.person)
    end
    self
  end

  def change_payout_amount_for_manager(payout)
    return if payout.day_62 or payout.day_92 or payout.day_122 or payout.day_152
    payout.payout = 20.00
    self
  end
end