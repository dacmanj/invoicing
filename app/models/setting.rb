class Setting < ActiveRecord::Base
  attr_accessible :key, :value, :category
    
    
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
      logo_url: 'logo.png'
    }

    
    DEFAULT_CATEGORIES = { remittance_block: "html", masthead: "html", logo_url: "string" }
    
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
    
end
