class RingCentralCallDestination
  def write record
    return unless RingCentralCall.where(ring_central_call_num: record.ring_central_call_num).empty?
    record.save
  end

  def close; end
end