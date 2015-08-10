describe GroupMeBotQuery do

  let(:query) { TestGroupMeBotCallback.new.extend(GroupMeBotQuery) }

  describe 'time range determination' do
    it 'pulls the correct range for mtd' do
      query.keywords = ['mtd']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current.beginning_of_month)
      expect(query.end_date).to eq(Date.current + 1.day)
    end

    it 'pulls the correct range for yesterday' do
      query.keywords = ['yesterday']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current - 1.day)
      expect(query.end_date).to eq(Date.current)
    end

    it 'pulls the correct range for this weekend' do
      query.keywords = ['this', 'weekend']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current.beginning_of_week + 4.days)
      expect(query.end_date).to eq(Date.current.beginning_of_week + 1.week)
    end

    it 'pulls the correct range for last weekend' do
      query.keywords = ['last', 'weekend']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current.beginning_of_week - 3.days)
      expect(query.end_date).to eq(Date.current.beginning_of_week)
    end

    it 'pulls the correct range for wtd' do
      query.keywords = ['wtd']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current.beginning_of_week)
      expect(query.end_date).to eq(Date.current + 1.day)
    end

    it 'pulls the correct range for this week' do
      query.keywords = ['this', 'week']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current.beginning_of_week)
      expect(query.end_date).to eq(Date.current.beginning_of_week + 1.week)
    end

    it 'pulls the correct range for last week' do
      query.keywords = ['last', 'week']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current.beginning_of_week - 1.week)
      expect(query.end_date).to eq(Date.current.beginning_of_week)
    end

    it 'pulls the correct range for this month' do
      query.keywords = ['this', 'month']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current.beginning_of_month)
      expect(query.end_date).to eq(Date.current.end_of_month + 1.day)
    end

    it 'pulls the correct range for last month' do
      query.keywords = ['last', 'month']
      query.determine_date_range
      expect(query.start_date).to eq(Date.current.beginning_of_month - 1.month)
      expect(query.end_date).to eq(Date.current.beginning_of_month)
    end

    it 'pulls the correct day after midnight UTC' do
      @time_now = Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)
      allow(Time).to receive(:now).and_return(@time_now)
      after_midnight_utc = Time.now.utc.beginning_of_day + 27.hours
      Timecop.freeze(after_midnight_utc)
      query.keywords = ['today']
      query.determine_date_range
      Timecop.return
      expect(query.start_date).to eq(Date.current)
      expect(query.end_date).to eq(Date.current + 1.day)
    end
  end

  describe 'result formatting' do
    let(:results) {
      [
          { 'name' => 'Atlanta Territory', 'count' => '12' },
          { 'name' => 'Boston Territory', 'count' => '17' }
      ]
    }
    let(:result_strings) {
      ["[#1] Atlanta Territory: 12\n[#2] Boston Territory: 17\n\n***TOTAL: 29"]
    }

    it 'formats results as a string' do
      expect(query.messages(results)).to eq(result_strings)
    end
  end
end

class TestGroupMeBotCallback
  include GroupMeBotSalesMessages

  attr_accessor :keywords,
                :query_string

  def messages(results)
    self.sales_generate_messages(results)
  end
end