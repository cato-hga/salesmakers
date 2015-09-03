module ActiveRecordExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def all_active
      where active: true
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)