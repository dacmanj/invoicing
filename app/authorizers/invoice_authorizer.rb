# app/authorizers/invoice_authorizer.rb
class InvoiceAuthorizer < ApplicationAuthorizer
  # Class method: can this user at least sometimes create a Schedule?
  def self.creatable_by?(user)
    user.has_role? :staff
  end

  def self.readable_by?(user)
    user.has_role? :staff
  end

  def self.updatable_by?(user)
    user.has_role? :staff
  end
    
  def deletable_by?(user)
    user.has_role? :admin
  end
end
