require "rubygems"

# convenience class
class T
  class << self
    # ['tenant1', 'tenant2', ...]
    def names
      @@names ||= Apartment.tenant_names.sort
    end

    # { 0 => 'public', 1 => 'tenant1', ...}
    def hash
      @@hash ||= { 0 => 'public' }.merge(
        (1..(T.names.length)).to_a
        .product(T.names)
        .to_h
      )
    end

    def switch! arg
      Apartment::Tenant.switch!(arg) if T.hash.value?(arg)
    end

    # current tenant
    def me
      Apartment::Tenant.current
    end

    def exists? arg
      T.names.include? arg
    end

    # ask to switch the tenant
    def ask
      WelcomeClass.select_tenant
    end
  end
end

# select tenant when entering console
class WelcomeClass
  def self.select_tenant
    puts "Available tenants: #{T.hash}"

    print "Select tenant: "
    tenant = gets.strip # ask which one?

    unless tenant.empty?
      # by name
      if T.exists?(tenant)
        T.switch!(tenant)

      # by index position
      # string has digit + tenant index present
      elsif tenant[/\d/].present? && T.hash.key?(tenant.to_i)
        T.switch!(T.hash[tenant.to_i])

      # not found = no action
      else
        puts "Tenant not found in list '#{tenant}'"
      end
    end

    # announce current tenant
    puts "You are now Tenant '#{T.me}'"
  end
end

# run the code at `bin/rails console`
Pry.config.exec_string = WelcomeClass.select_tenant