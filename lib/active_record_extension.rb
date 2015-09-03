module ActiveRecordExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def active
      where active: true
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)