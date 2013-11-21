# == Schema Information
#
# Table name: email_templates
#
#  id         :integer          not null, primary key
#  subject    :string(255)
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

class EmailTemplate < ActiveRecord::Base
  attr_accessible :name, :message, :subject
end
