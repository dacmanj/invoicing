# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  category   :text
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Setting, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
