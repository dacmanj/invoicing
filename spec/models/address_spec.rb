# == Schema Information
#
# Table name: addresses
#
#  id            :integer          not null, primary key
#  city          :string(255)
#  state         :string(255)
#  zip           :string(255)
#  email         :string(255)
#  phone         :string(255)
#  fax           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contact_id    :integer
#  address_lines :text
#

require 'spec_helper'

describe Address do
  pending "add some examples to (or delete) #{__FILE__}"
end
