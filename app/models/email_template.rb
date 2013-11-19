class EmailTemplate < ActiveRecord::Base
  attr_accessible :name, :message, :subject
end
