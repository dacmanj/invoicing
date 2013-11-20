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

  def self.code_collection(category)
	Code.find_all_by_category(category).map{ |h| [h.value,h.code]} 
  end
end
