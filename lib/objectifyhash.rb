# coding: utf-8
require 'monkey_string'

module ObjectifyHash
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
    define_singleton_method key.to_sym do
      value;
    end

    define_singleton_method key.to_s.snake_case.to_sym do
      value;
    end

    define_singleton_method "#{key}=".to_sym do |set_value|
      value = set_value;
      update_hash(key, value)
    end

    define_singleton_method "#{key}=".snake_case.to_sym do |set_value|
      value = set_value;
      update_hash(key, value)
    end

    define_singleton_method :to_h do
      @original_hash
    end

    define_singleton_method :eql? do | value_to_compare |
      return compare_hash(value_to_compare)
    end

    define_singleton_method :equal? do | value_to_compare |
      return compare_hash(value_to_compare)
    end

    define_singleton_method :== do | value_to_compare |
      return compare_hash(value_to_compare)
    end

    define_singleton_method :!= do | value_to_compare |
      return !compare_hash(value_to_compare)
    end
  end

  def compare_hash(value_to_compare)
    unless value_to_compare.is_a? (ObjectifyHash)
      return false
    end

    unless to_h.to_s.eql? value_to_compare.to_h.to_s
      return false
    end

    return true
  end

  def update_hash(key_to_update, value_to_update)
     @original_hash.update(@original_hash) do |key,value|
      if key.to_sym == key_to_update
        value = value_to_update
      else
        value = value
      end
    end
  end

  def values_at *args
    args.map do |key|
      self.respond_to?( key ) ? self.method( key ).call : nil
    end
  end

  #retro bunker compatibility
  def [] val
    $stderr.puts 'DEPRECATION WARNING #[] CALLED ON OBJECT'.bold.red
    raise NameError unless self.respond_to?( val.to_sym )
    self.method( val ).call
  end

end

if $0 == __FILE__
  a = '{
    "content": {
    "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0",
    "totalLicenses": 10,
    "type": "EST",
    "offerId": "51d4f5d9-ba88-427a-b430-274e9663980c",
    "purchaseDate": "2015-07-07T09:23:17.49Z",
    "ownerId": "6ecb8629-374a-4063-81da-c329f29b405d",
    "ownership": "UserOwnership",
    "canPlay": true,
    "playbackRules": {},
    "canSendToStb": false,
    "canSendSpecs": {},
    "content": {
    "asset": {},
    "resume": {},
    "contents": [
    {
    "asset": {
    "title": "Back to the Future",
    "altTitle": "Back to the Future - Season",
    "slug": "back-to-the-future",
    "shortSynopsis": "A high school student is accidentally sent 30 years into the past in a time-traveling sports car invented by his friend, Dr. Emmett Brown, and must make sure his high-school-age parents unite in order to save his own existence.",
    "duration": 0,
    "number": 1,
    "year": 0,
    "rel": "asset",
    "lastUpdateDate": "2015-03-24T13:52:02Z",
    "assetType": "Season",
    "catalogSection": "Movies",
    "id": "11eb97d3-c8ee-4502-a9dd-410c8b4dd66a",
    "links": [
    {
    "rel": "self",
    "href": "https://qa.skystore.com/api/webP3/v2/catalog/assets/11eb97d3-c8ee-4502-a9dd-410c8b4dd66a/back-to-the-future",
    "method": "GET",
    "needsAuthentication": false
    },
    {
    "rel": "image",
    "href": "http://qa.skystore.com/api/img/asset/en/F80DF38A-D09C-41C9-A419-81C6CF8582F3_3E1EE8E3-D376-4687-8C57-CC57475DE4FE_2015-6-22-T11-11-30.jpg?s={{w}}x{{h}}",
    "needsAuthentication": false
    }
    ]
    },
    "resume": {
    "asset": {
    "title": "Back to the Future",
    "altTitle": "Back to the Future - Movie",
    "slug": "back-to-the-future",
    "shortSynopsis": "A high school student is accidentally sent 30 years into the past in a time-traveling sports car invented by his friend, Dr. Emmett Brown, and must make sure his high-school-age parents unite in order to save his own existence.",
    "duration": 116,
    "year": 1985,
    "rel": "asset",
    "lastUpdateDate": "2015-01-09T11:36:08Z",
    "assetType": "Programme",
    "catalogSection": "Movies",
    "id": "86b39480-87e6-4a99-891a-563fb780871b",
    "links": [
    {
    "rel": "self",
    "href": "https://qa.skystore.com/api/webP3/v2/catalog/assets/86b39480-87e6-4a99-891a-563fb780871b/back-to-the-future",
    "method": "GET",
    "needsAuthentication": false
    },
    {
    "rel": "image",
    "href": "http://qa.skystore.com/api/img/asset/en/F80DF38A-D09C-41C9-A419-81C6CF8582F3_72C3E254-7095-45BB-BF83-3055E08CC204_2015-6-22-T11-12-46.jpg?s={{w}}x{{h}}",
    "needsAuthentication": false
    }
    ]
    },
    "video": {
    "playbackPositionInSeconds": 0,
    "progressPercent": 0,
    "links": [
    {
    "rel": "videoOptions",
    "href": "https://qa.skystore.com/api/webP3/v2/user/entitlements/fa879cad-8753-4040-8702-fd0937eeb7f4/86b39480-87e6-4a99-891a-563fb780871b/video/options",
    "method": "GET",
    "needsAuthentication": true
    }
    ]
    }
    },
    "links": [
    {
    "rel": "self",
    "href": "https://qa.skystore.com/api/webP3/v2/user/entitlements/fa879cad-8753-4040-8702-fd0937eeb7f4/11eb97d3-c8ee-4502-a9dd-410c8b4dd66a",
    "method": "GET",
    "needsAuthentication": true
    }
    ]
    },
{
    "asset": {
    "title": "Back to the Future FAKE ",
    "altTitle": "Back to the Future - Season",
    "slug": "back-to-the-future",
    "shortSynopsis": "A high school student is accidentally sent 30 years into the past in a time-traveling sports car invented by his friend, Dr. Emmett Brown, and must make sure his high-school-age parents unite in order to save his own existence.",
    "duration": 0,
    "number": 1,
    "year": 0,
    "rel": "asset",
    "lastUpdateDate": "2015-03-24T13:52:02Z",
    "assetType": "Season",
    "catalogSection": "Movies",
    "id": "11eb97d3-c8ee-4502-a9dd-410c8b4dd66a",
    "links": [
    {
    "rel": "self",
    "href": "https://qa.skystore.com/api/webP3/v2/catalog/assets/11eb97d3-c8ee-4502-a9dd-410c8b4dd66a/back-to-the-future",
    "method": "GET",
    "needsAuthentication": false
    },
    {
    "rel": "image",
    "href": "http://qa.skystore.com/api/img/asset/en/F80DF38A-D09C-41C9-A419-81C6CF8582F3_3E1EE8E3-D376-4687-8C57-CC57475DE4FE_2015-6-22-T11-11-30.jpg?s={{w}}x{{h}}",
    "needsAuthentication": false
    }
    ]
    },
    "resume": {
    "asset": {
    "title": "Back to the Future",
    "altTitle": "Back to the Future - Movie",
    "slug": "back-to-the-future",
    "shortSynopsis": "A high school student is accidentally sent 30 years into the past in a time-traveling sports car invented by his friend, Dr. Emmett Brown, and must make sure his high-school-age parents unite in order to save his own existence.",
    "duration": 116,
    "year": 1985,
    "rel": "asset",
    "lastUpdateDate": "2015-01-09T11:36:08Z",
    "assetType": "Programme",
    "catalogSection": "Movies",
    "id": "86b39480-87e6-4a99-891a-563fb780871b",
    "links": [
    {
    "rel": "self",
    "href": "https://qa.skystore.com/api/webP3/v2/catalog/assets/86b39480-87e6-4a99-891a-563fb780871b/back-to-the-future",
    "method": "GET",
    "needsAuthentication": false
    },
    {
    "rel": "image",
    "href": "http://qa.skystore.com/api/img/asset/en/F80DF38A-D09C-41C9-A419-81C6CF8582F3_72C3E254-7095-45BB-BF83-3055E08CC204_2015-6-22-T11-12-46.jpg?s={{w}}x{{h}}",
    "needsAuthentication": false
    }
    ]
    },
    "video": {
    "playbackPositionInSeconds": 0,
    "progressPercent": 0,
    "links": [
    {
    "rel": "videoOptions",
    "href": "https://qa.skystore.com/api/webP3/v2/user/entitlements/fa879cad-8753-4040-8702-fd0937eeb7f4/86b39480-87e6-4a99-891a-563fb780871b/video/options",
    "method": "GET",
    "needsAuthentication": true
    }
    ]
    }
    },
    "links": [
    {
    "rel": "self",
    "href": "https://qa.skystore.com/api/webP3/v2/user/entitlements/fa879cad-8753-4040-8702-fd0937eeb7f4/11eb97d3-c8ee-4502-a9dd-410c8b4dd66a",
    "method": "GET",
    "needsAuthentication": true
    }
    ]
    }
    ]
    },
    "id": "fa879cad-8753-4040-8702-fd0937eeb7f4",
    "links": [
    {
    "rel": "deviceStatus",
    "href": "https://qa.skystore.com/api/webP3/v2/user/devices/status",
    "method": "GET",
    "needsAuthentication": true
    }
    ]
    },
    "meta": {
    "httpCode": 200
    }
    }'

  require 'json'
  hash = JSON.parse a

  class A
    include HashToObj
  end

  a = A.new
  a.convert_and_define hash
  # puts A.content
  puts  a.content.assetId                            == hash['content']['assetId']
  puts a.content.class
  puts A::Content
  puts a.content.links.class
  puts a.content.links.by_rel('deviceStatus').href
  puts a.content.content.contents.is_a? Array
  puts a.content.content.contents.first.is_a? A::Content::Content::Content  #notice the missing Contents class
  puts a.content.content.contents.first.asset.title  == hash['content']['content']['contents'].first['asset']['title']
  puts a.content.content.contents.last.asset.title   == hash['content']['content']['contents'].last['asset']['title']
  puts a.content.totalLicenses                       == hash['content']['totalLicenses']
  puts a.content.total_licenses                      == hash['content']['totalLicenses']
  puts a.content.content.contents.last.type.nil?



end