# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  category   :text
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Setting < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  attr_accessible :key, :value, :category, :file
  before_save :update_value_if_attached_file
    
  has_attached_file :file,
    :storage => :google_drive,
    :google_drive_credentials => "#{Rails.root}/config/google_drive.yml",
    :google_drive_options => {
      :public_folder_id => "0Byxf7_dzGKoEVUg5X0FnOE02NmM",
      :path => proc { |style| "#{id}_#{file.original_filename}" }
   }
    
  DEFAULT_VALUES = { 
      
      remittance_block: '<p style="font-weight: bold;">MAKE CHECKS/REMITTANCE PAYABLE TO:<br>
            PFLAG National</p>
            <p>If you have any questions concerning this invoice, contact us at (202)-467-8180 or <a href="invoices@pflag.org?subject=Invoice%20%23<%=@invoice.id%>">invoices@pflag.org</a></p>', 
      
      masthead: '            <center>
              <h4>PFLAG National<br>
              <i>Moving equality forward&hellip;</i><br>
              TAX ID # 95-3750694<br>
              Download our W9 at <a href="http://pflag.org/w9">pflag.org/w9</a></h4>
              <p>
                1828 L St NW, Ste 660<br>Washington, DC 20036<br>
                (202) 467-8180 | Fax: (202) 467-8194<br>
                <a href="mailto:info@pflag.org">INFO@PFLAG.ORG</a> | <a href="http://www.pflag.org">WWW.PFLAG.ORG</a>
              </p>
            </center>',
      logo: 'logo.png', valid_ar_accounts:'1110,1111,1210,1211,1212,1221', valid_payment_types:'Check,Credit,Card,ACH,Cash,Adjustment'
    }

    
    DEFAULT_CATEGORIES = { remittance_block: "html", masthead: "html", logo: "file", valid_ar_accounts: "string", valid_payment_types:"string" }
    
    def self.reinitialize
       Setting.all.each do |h| h.delete end
       self.initialize
    end
    def self.initialize
       DEFAULT_VALUES.each do |k,v|
         if Setting.find_by_key(k.to_s).nil?
           s = Setting.new(:key => k, :category => DEFAULT_CATEGORIES[k], :value => DEFAULT_VALUES[k])
           s.save
         end
       end
       Setting.all    
    end

    def self.find_template(key)
      setting = Setting.find_by_key(key)
      value = (setting.value unless setting.blank?) || DEFAULT_VALUES[key.to_sym] || "DEFAULTS MISSING, PLEASE INITIALIZE DB"
    end
    private
    def update_value_if_attached_file
        self.value = self.file.url if self.category == "file"
    end
end
