class EmailRecord < ActiveRecord::Base
  belongs_to :account
  belongs_to :invoice

  attr_accessible :account_id, :email, :invoice_id, :message, :subject
end
