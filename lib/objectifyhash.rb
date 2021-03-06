# coding: utf-8
require_relative 'objectifyhash/hash'

module ObjectifyHash
  alias_method :eql?, :==
  attr_accessor :values_to_compare

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
    @values_to_compare||=[]
    @original_hash.each do |key, value|
      key = 'klass' if key == 'class'
      key = key.to_sym
      case
        when key == :id
          set :guid, value
        when key == :method
          set :verb, value
        when EXCEPTIONS.key?( key )
          set key, EXCEPTIONS[ key ].call( value )
        when value.is_a?(Hash)
          klass  = get_new_class key
          # puts "Going to instanciate class based on #{key}"
          object = klass.new( value )
          # puts 'success'
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
    name = "#{name.capitalize}_".to_sym if Object.constants.include? name.capitalize.to_sym
    name = name.to_s.sub(/^_/, '').to_sym
    self.class.const_defined?(name.capitalize) ?
        self.class.const_get(name.capitalize) :
        self.class.const_set(name.capitalize, ObjectifyHash::GenericObject)
  end


  def set key, value
    method_name = Object.instance_methods.include?( key ) ? :"_#{key}_" : key.to_sym
    @values_to_compare.push method_name
    self.__send__(:define_singleton_method, method_name, Proc.new do value; end )
  end

  def values_at *args
    args.map do |key|
      self.respond_to?( key ) ? self.method( key ).call : nil
    end
  end

  def ignore_equal key = nil
    @ignore_equal||=[]
    @ignore_equal.push key if key
    @ignore_equal
  end

  def == other
    return false unless other.respond_to? :values_to_compare
    return false unless self.values_to_compare - other.values_to_compare == [] #should not use == cuz arrays can have different orders
    (self.values_to_compare - ignore_equal ).each do |value|
      return false unless self.method(value).() == other.method(value).()
    end
    return true
  end


  def method_missing m, *args, &block
    super m, *args, &block if args.length > 0 or block_given?
    nil
  end

  #retro bunker compatibility
  def [] val
    $stderr.puts 'DEPRECATION WARNING #[] CALLED ON OBJECT'
    raise NameError unless self.respond_to?( val.to_sym )
    self.method( val ).call
  end

  def to_h
    h = {}
    values_to_compare.each do |m|
      if self.method( m ).().nil? and NULLABLE_KEYS.include?( m )
        next
      end
      if self.method( m ).().respond_to? :values_to_compare
        h[ m.to_sym ] = self.method( m ).().to_h
      elsif self.method( m ).().is_a? Array
        h[ m.to_sym ] = un_objectify_array( self.method( m ).() )
      else
        h[ m.to_sym ] = self.method( m ).()
      end
    end
    return h
  end

  def empty?
    self.values_to_compare.empty?
  end

  private
    def un_objectify_array array
    array.map do |v|
      if v.is_a? Array
        un_objectify_array v
      elsif v.respond_to? :values_to_compare
        v.to_h
      else
        v
      end
    end
  end




end

