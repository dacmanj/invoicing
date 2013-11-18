# == Schema Information
#
# Table name: codes
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  code       :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Code < ActiveRecord::Base
  attr_accessible :category, :code, :value
end
