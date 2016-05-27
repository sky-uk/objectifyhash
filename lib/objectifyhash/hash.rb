# coding: utf-8
class Hash
  def to_obj
    ObjectifyHash::GenericObject.new( self )
  end
end