# == Schema Information
#
# Table name: email_records
#
#  id         :integer          not null, primary key
#  account_id :integer
#  invoice_id :integer
#  email      :string(255)
#  subject    :string(255)
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe EmailRecord do
  pending "add some examples to (or delete) #{__FILE__}"
end
