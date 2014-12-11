class UserAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.has_role? :admin
  end

  def self.readable_by?(user)
      user.has_role? :admin
  end
    
  def readable_by?(user)
    resource == user or user.has_role? :admin

  end
  def self.updateable_by?(user)
    user.has_role? :admin
  end
  def updatable_by?(user)
    resource == user or user.has_role? :admin
  end
    
  def deletable_by?(user)
    user.has_role? :admin
  end
end
