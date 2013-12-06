# == Schema Information
#
# Table name: email_records
#
#  id         :integer          not null, primary key
#  account_id :integer
#  invoice_id :integer
#  email      :string(255)
#  subject    :string(255)
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cc         :string(255)
#  bcc        :string(255)
#

class EmailRecord < ActiveRecord::Base
  belongs_to :account
  belongs_to :invoice

  attr_accessible :account_id, :email, :invoice_id, :message, :subject, :cc, :bcc
end
