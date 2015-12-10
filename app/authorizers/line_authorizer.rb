# app/authorizers/line_authorizer.rb
class LineAuthorizer < ApplicationAuthorizer

  def self.creatable?(user)
    user.has_any_role? :staff, :admin
  end
    def self.updatable?(user)
    user.has_any_role? :staff, :admin
  end
    def self.readable?(user)
    user.has_any_role? :staff, :admin
  end
  def self.deletable?(user)
    user.has_any_role? :staff, :admin
  end
  def creatable?(user)
    user.has_any_role? :staff, :admin
  end
    def updatable?(user)
    user.has_any_role? :staff, :admin
  end
    def readable?(user)
    user.has_any_role? :staff, :admin
  end
  def deletable?(user)
    user.has_any_role? :staff, :admin
  end    
end
