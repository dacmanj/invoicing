# app/authorizers/invoice_authorizer.rb
class InvoiceAuthorizer < ApplicationAuthorizer

  def self.emailable_by?(user)
    user.has_any_role? :staff, :admin
  end
end
