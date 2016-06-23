# coding: utf-8
require 'monkey_string'

module ObjectifyHash
  alias_method :eql?, :==

  EXCEPTIONS     = {
      data: Proc.new do | value | value; end
  }
  NULLABLE_KEYS = []

  class GenericObject
    include ObjectifyHash

    def initialize hash
      convert_and_define hash
    end

  end


  def convert_and_define hash
    @original_hash = hash
    @original_hash.each do |key, value|
      key = key.to_sym
      case
        when key == :id
          set :guid, value
        when EXCEPTIONS.key?( key )
          set key, EXCEPTIONS[ key ].call( value )
        when value.is_a?(Hash)
          klass  = get_new_class key
          object = klass.new( value )
          set key, object
        when value.is_a?(Array)
          set key, objectify_array(value, key)
        else
          set key, value
      end
    end

    NULLABLE_KEYS.each do |key|
      unless self.respond_to?( key )
        set key, nil
      end
    end

  end


  def objectify_array array,name
    array.map do |elem|
      if EXCEPTIONS.key? name
        EXCEPTIONS[ name ].call( elem )
      else
        if elem.is_a? Hash
          klass = get_new_class name.to_s.sub(/s$/, '').to_sym
          klass.new elem
        else
          elem
        end
      end
    end
  end

  def get_new_class name
    self.class.const_defined?(name.capitalize) ? self.class.const_get(name.capitalize) : self.class.const_set(name.capitalize, ObjectifyHash::GenericObject)
  end


  def set key, value
    self.send(:define_singleton_method, key.to_sym, Proc.new do value; end )
    self.send(:define_singleton_method, key.to_s.snake_case.to_sym, Proc.new do value; end )
  end

  def values_at *args
    args.map do |key|
      self.respond_to?( key ) ? self.method( key ).call : nil
    end
  end

  def == other
    return false unless other.respond_to? :values_to_compare
    return false unless self.values_to_compare - other.values_to_compare == [] #should not use == cuz arrays can have different orders
    self.values_to_compare.each do |value|
      return false unless self.method(value).() == other.method(value).()
    end
    return true
  end


  #retro bunker compatibility
  def [] val
    $stderr.puts 'DEPRECATION WARNING #[] CALLED ON OBJECT'.bold.red
    raise NameError unless self.respond_to?( val.to_sym )
    self.method( val ).call
  end

  def values_to_compare
    methods = []
    self.public_methods(false).each do |method|
      methods.push method if self.method(method).arity == 0
    end
    return methods
  end

end

