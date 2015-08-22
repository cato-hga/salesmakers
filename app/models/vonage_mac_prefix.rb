class VonageMacPrefix < ActiveRecord::Base
  before_save :uppercase

  validates :prefix, length: { is: 6 }

  private

  def uppercase
    self.prefix = self.prefix.upcase
  end
end
