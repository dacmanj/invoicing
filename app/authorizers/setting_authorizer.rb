class SettingAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.has_role? :admin
  end

  def self.readable_by?(user)
    user.has_role? :admin
  end
  def self.updateable_by?(user)
    user.has_role? :admin
  end
  def self.deletable_by?(user)
    user.has_role? :admin
  end
end
