# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer

  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] user - whatever represents the current user in your app
  # @return [Boolean]
  def self.default(adjective, user)
    case adjective
    when :creatable
        user.has_any_role? :staff, :admin
    when :updatable
        user.has_any_role? :staff, :admin
    when :readable
        user.has_any_role? :customer, :staff, :auditor
    when :deletable
        user.has_role? :admin
    else
        user.has_role? :admin
    end
  end

end
