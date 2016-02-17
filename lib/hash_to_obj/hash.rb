# coding: utf-8
class Hash
  def to_obj
    HashToObj::GenericObject.new( self )
  end
end