class VCP07012015HPSShiftsDestination
  def write hps_shift
    saved_hps_shift = VCP07012015HPSShift.new hps_shift
    return unless saved_hps_shift.valid?
    saved_hps_shift.save
  end

  def close; end
end