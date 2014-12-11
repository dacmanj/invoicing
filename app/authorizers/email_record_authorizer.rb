class EmailRecordAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.has_role? :staff
  end

  def self.readable_by?(user)
    user.has_role? :staff
  end
  def self.updateable_by?(user)
    user.has_role? :staff
  end
  def self.deletable_by?(user)
    user.has_role? :admin
  end
end
