require "thread"

class Thread
  alias_method :_initialize, :initialize

  def initialize(*args, &block)
    inheritable_attributes = Thread.current.inheritable_attributes
    _initialize(*args) do
      Thread.current.inheritable_attributes = inheritable_attributes
      block.call
    end
  end

  # Mutating the resulting hash may not change value.
  # Instead add new key with the following:
  # Thread#inheritable_attributes = Thread#inheritable_attributes.merge(:key => :value)
  # @return [Hash]
  def inheritable_attributes
    self[:inheritable_attributes] || {}
  end

  # @param [Hash] value
  # @return [Thread]
  def inheritable_attributes=(value)
    self[:inheritable_attributes] = value
    self
  end
end
