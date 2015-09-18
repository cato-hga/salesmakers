# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  attachable_id   :integer          not null
#  attachable_type :string           not null
#  attachment_uid  :string
#  attachment_name :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  person_id       :integer          not null
#

require 'rails_helper'

describe Attachment do
  subject { build :attachment }
end
