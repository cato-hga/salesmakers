describe GroupMeBotSalesQuery do
  let(:query) { TestGroupMeBotCallback.new.extend(GroupMeBotSalesQuery) }

  describe 'time range determination' do
    it 'pulls the correct range for mtd' do
      query.keywords = ['mtd']
      query.determine_date_range
      expect(query.start_date).to eq(Date.today.beginning_of_month)
      expect(query.end_date).to eq(Date.tomorrow)
    end

    it 'pulls the correct range for yesterday' do
      query.keywords = ['yesterday']
      query.determine_date_range
      expect(query.start_date).to eq(Date.yesterday)
      expect(query.end_date).to eq(Date.today)
    end

    it 'pulls the correct range for this weekend' do
      query.keywords = ['this', 'weekend']
      query.determine_date_range
      expect(query.start_date).to eq(Date.today.beginning_of_week + 4.days)
      expect(query.end_date).to eq(Date.today.beginning_of_week + 1.week)
    end

    it 'pulls the correct range for last weekend' do
      query.keywords = ['last', 'weekend']
      query.determine_date_range
      expect(query.start_date).to eq(Date.today.beginning_of_week - 3.days)
      expect(query.end_date).to eq(Date.today.beginning_of_week)
    end

    it 'pulls the correct range for wtd' do
      query.keywords = ['wtd']
      query.determine_date_range
      expect(query.start_date).to eq(Date.today.beginning_of_week)
      expect(query.end_date).to eq(Date.tomorrow)
    end

    it 'pulls the correct range for this week' do
      query.keywords = ['this', 'week']
      query.determine_date_range
      expect(query.start_date).to eq(Date.today.beginning_of_week)
      expect(query.end_date).to eq(Date.today.beginning_of_week + 1.week)
    end

    it 'pulls the correct range for last week' do
      query.keywords = ['last', 'week']
      query.determine_date_range
      expect(query.start_date).to eq(Date.today.beginning_of_week - 1.week)
      expect(query.end_date).to eq(Date.today.beginning_of_week)
    end

    it 'pulls the correct range for this month' do
      query.keywords = ['this', 'month']
      query.determine_date_range
      expect(query.start_date).to eq(Date.today.beginning_of_month)
      expect(query.end_date).to eq(Date.today.end_of_month + 1.day)
    end

    it 'pulls the correct range for last month' do
      query.keywords = ['last', 'month']
      query.determine_date_range
      expect(query.start_date).to eq(Date.today.beginning_of_month - 1.month)
      expect(query.end_date).to eq(Date.today.beginning_of_month)
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
      ["Atlanta Territory: 12\nBoston Territory: 17\n\n***TOTAL: 29"]
    }

    it 'formats results as a string', pending: 'THIS SHOULD NOT BE PENDING AFTER FEB 19TH UNCOMMENT ME' do
      expect(query.messages(results)).to eq(result_strings)
    end
  end
end

class TestGroupMeBotCallback
  attr_accessor :keywords,
                :query_string

  def messages(results)
    self.generate_messages(results)
  end
end