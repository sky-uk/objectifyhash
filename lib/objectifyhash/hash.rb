# coding: utf-8
class Hash
  def to_obj
    GenericObject.new( self )
  end
end