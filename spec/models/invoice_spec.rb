# == Schema Information
#
# Table name: invoices
#
#  id                 :integer          not null, primary key
#  contact_id         :integer
#  account_id         :integer
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  date               :date
#  primary_contact_id :integer
#  ar_account         :string(255)
#  void               :boolean          default(FALSE)
#  balance_due        :integer
#  last_email         :date
#  total              :decimal(, )
#

require 'spec_helper'

describe Invoice do
  pending "add some examples to (or delete) #{__FILE__}"
end
