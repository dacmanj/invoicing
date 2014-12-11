# app/authorizers/contact_authorizer.rb
class ContactAuthorizer < ApplicationAuthorizer

  def self.creatable_by?(user)
    user.has_role? :staff
  end

  def self.readable_by?(user)
    user.has_role? :staff or user.has_role? :auditor
  end

  def self.updatable_by?(user)
    user.has_role? :staff
  end
  def self.deletable_by?(user)
    user.has_role? :admin
  end
  def self.emailable_by?(user)
    user.has_role? :staff
  end
end
