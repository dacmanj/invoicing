# == Schema Information
#
# Table name: lines
#
#  id          :integer          not null, primary key
#  description :string(255)
#  item_id     :integer
#  quantity    :decimal(, )
#  unit_price  :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Line do
  pending "add some examples to (or delete) #{__FILE__}"
end
