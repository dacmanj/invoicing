# == Schema Information
#
# Table name: companies
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  default_account_ar_account :string(255)
#  contact_id                 :integer
#  address_id                 :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  database_id                :string(255)
#

require 'spec_helper'

describe Company do
  pending "add some examples to (or delete) #{__FILE__}"
end
