class User
  def initialize
    @ldap = Net::LDAP.new
    @ldap.host = LDAP_CONFIG["host"]
    @ldap.port = LDAP_CONFIG["port"]
    @ldap.auth LDAP_CONFIG["auth_user"], LDAP_CONFIG["auth_password"]
  end

  def memberOf(user,group)
    group_filter = Net::LDAP::Filter.eq( "objectClass", LDAP_CONFIG["group_class"] )
    cn_filter = Net::LDAP::Filter.eq(LDAP_CONFIG["group_dn"],group)
    joined_filter = Net::LDAP::Filter.join(group_filter, cn_filter)
    result = @ldap.search( :base => LDAP_CONFIG["base"], :filter => joined_filter, :attributes=> '*').first
    result["memberuid"].include? user
  end

  def authenticate(user,password)
    @@user = user
    result = @ldap.bind_as(
        :base => LDAP_CONFIG["base"],
        :filter => "(#{LDAP_CONFIG["user_dn"]}=#{user})",
        :password => password)
    if result
      memberOf(user,LDAP_CONFIG["user_group"])
    else
      false
    end
  end

  def adminUser?(user = @@user)
    memberOf(user,LDAP_CONFIG["admin_group"])
  end

  def self.adminUser?(user)
    r = User.new
    r.memberOf(user,LDAP_CONFIG["admin_group"])
  end

  def self.authenticate(user,password)
    r = User.new
    r.authenticate(user,password)
  end

end
