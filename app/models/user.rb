# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :email
  validates_presence_of :name

  scope :notify_all, lambda{ where("email IN(?)", ["dmanuel@pflag.org","awalker@pflag.org","vdiponio@pflag.org"])}

  def self.create_with_omniauth(auth)
    email = auth["info"]["email"]
    domain = /@(.+$)/.match(email)[1]
    if (domain.casecmp("pflag.org") != 0 || domain.casecmp("centeronhalsted.org") != 0)
      raise UserDomainError, "#{domain} is an invalid email address domain."
    else
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        if auth['info']
           user.name = auth['info']['name'] || ""
           user.email = auth['info']['email'] || ""
        end
      end
    end
  end
end

class UserDomainError < StandardError
end
