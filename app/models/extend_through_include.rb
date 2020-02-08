module ExtendThroughInclude
  def self.included(klass)
    klass.extend ClassMethods
  end

  def instance_method
    "this is an instance of #{self.class}"
  end

  module ClassMethods
    def class_method
      "this is a method on the #{self} class"
    end
  end
end