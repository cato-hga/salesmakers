require 'maas360_lockdown_job'

module PersonEmploymentModelExtension

  def termination_date_invalid?
    begin
      not self.employments.empty? and
          self.employments.first.end and
          self.employments.first.end.strftime('%Y').to_i < 2008
    rescue
      return false
    end
  end

  def terminated?
    self.employments.count > 0 and self.employments.first.end
  end

  def hire_date
    if self.employments.count > 0
      self.employments.first.start
    else
      nil
    end
  end

  def term_date
    if self.termination_date_invalid?
      nil
    elsif self.terminated?
      self.employments.first.end
    else
      nil
    end
  end

  def separate(separated_at = Time.now, auto = false)
    if self.update(active: false, updated_at: separated_at)
      take_down_candidate_count
      MaaS360LockdownJob.perform_later self
      return if auto
      if self.devices.any?
        AssetsMailer.separated_with_assets_mailer(self).deliver_later
        AssetsMailer.asset_return_mailer(self).deliver_later
      else
        AssetsMailer.separated_without_assets_mailer(self).deliver_later
      end
    end
  end

  def commissionable?
    return true if self.person_pay_rates.empty?
    current_pay_rate = self.person_pay_rates.first
    return true unless current_pay_rate.rate == 12.0
    return false if self.person_areas.empty?
    if self.person_areas.first.area.name.downcase.include?('pilot ')
      true
    else
      false
    end
  end
end