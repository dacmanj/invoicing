# == Schema Information
#
# Table name: contacts
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  last_name   :string(255)
#  company_id  :integer
#  address_id  :integer
#  active      :boolean
#  database_id :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Contact do
  pending "add some examples to (or delete) #{__FILE__}"
end
