# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  description     :string(255)
#  revenue_gl_code :string(255)
#  quantity        :decimal(, )
#  unit_price      :decimal(, )
#  item_image_url  :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notes           :string(255)
#  recurring       :boolean
#  expensify_id    :string(255)
#

require 'spec_helper'

describe Item do
  pending "add some examples to (or delete) #{__FILE__}"
end
