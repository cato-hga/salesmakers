require 'apis/ring_central'

class RingCentralSource
  def initialize
    ring_central = RingCentral.new
    if ring_central
      @calls = ring_central.call_logs || []
    else
      @calls = []
    end
  end

  def each
    @calls.each do |call|
      yield call
    end
  end
end