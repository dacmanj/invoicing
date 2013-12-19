# == Schema Information
#
# Table name: lines
#
#  id          :integer          not null, primary key
#  description :text
#  item_id     :integer
#  quantity    :decimal(, )
#  unit_price  :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  invoice_id  :integer
#  hidden      :boolean
#  notes       :string(255)
#  position    :integer
#

require 'spec_helper'

describe Line do
  pending "add some examples to (or delete) #{__FILE__}"
end
