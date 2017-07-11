# coding: utf-8
require 'minitest/autorun'
require 'json'
require_relative File.join('..','lib','objectifyhash')
require_relative File.join('..','lib','objectifyhash', 'hash')

class A
  include ObjectifyHash

  ObjectifyHash::EXCEPTIONS.merge!( {duration: Proc.new do 100; end})


end
class Hash2ObjTest < Minitest::Test
  attr_accessor :a, :hash

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    a = '{
    "content": {
    "class": "batatas",
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
    "asset": {
      "duration":1
    },
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
    "needsAuthentication": true
    }
    ]
    }
    },
    "links": [
    {
    "rel": "self",
    "href": "https://qa.skystore.com/api/webP3/v2/user/entitlements/fa879cad-8753-4040-8702-fd0937eeb7f4/11eb97d3-c8ee-4502-a9dd-410c8b4dd66a",
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
        "needsAuthentication": true
    }
    ]
    }
    },
    "links": [
    {
    "rel": "self",
    "href": "https://qa.skystore.com/api/webP3/v2/user/entitlements/fa879cad-8753-4040-8702-fd0937eeb7f4/11eb97d3-c8ee-4502-a9dd-410c8b4dd66a",
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
    "needsAuthentication": true
    }
    ]
    },
    "meta": {
    "httpCode": 200
    }
    }'



    @hash = JSON.parse a
    @a = A.new
    @a.convert_and_define hash
  end


  def test_basic_nesting_key
   assert_equal a.content.assetId, hash['content']['assetId']
  end

  def test_correct_name_space
    assert_equal a.content.class, A::Content
  end

  def test_custom_exception
    assert_equal a.content.content.asset.duration, 100
  end

  def test_arrays_are_arrays
    assert a.content.content.contents.is_a?( Array)
  end
  def test_no_list_namespace
    assert a.content.content.contents.first.is_a?( A::Content::Content::Content)  #notice the missing Contents class
  end

  def test_deep_obj_with_arrays
    assert_equal a.content.content.contents.first.asset.title,  hash['content']['content']['contents'].first['asset']['title']
  end
  def test_deep_obj_with_arrays_via_last
    assert_equal a.content.content.contents.last.asset.title,  hash['content']['content']['contents'].last['asset']['title']
  end
  def test_camel_case_name
    assert_equal a.content.totalLicenses,  hash['content']['totalLicenses']
  end


  def test_custom_nullable_keys
    c = a.to_h
    ObjectifyHash::NULLABLE_KEYS.concat [:type]
    b = ObjectifyHash::GenericObject.new c
    assert b.content.content.contents.last.type.nil?
  end

  def test_to_obj
    assert_equal hash.to_obj.methods(false), a.methods(false)
  end

  def test_cloned_obj_is_eq
    assert_equal @a, @a.clone #dup won't work because it doesn't copy singleton methods made by objectifyhash
  end

  def test_object_is_different
    b = ObjectifyHash::GenericObject.new({a: 1, b:2, c: {kunamis: 'frescos'}})
    assert !(@a == b)
  end

  def test_can_ignore_some_fields
    b = ObjectifyHash::GenericObject.new({a: 1, b:2, c: {kunamis: 'frescos'}})
    c = ObjectifyHash::GenericObject.new({a: 1, b:2, c: {kunamis: 'frescos'}})

    b.ignore_equal :c

    assert_equal b,c
  end

  def test_to_h
    a      = {a: 1, b:{c: 2}, d: [1,3,4,[{z:1, y:[1]}]]}
    object = a.to_obj
    assert_equal a, object.to_h
  end

  def test_nil_if_does_not_have
    assert_nil @a.eyjafjallajökull
  end

  def test_not_empty
    refute(a.empty?)
  end

  def test_convert_class_to_klass
    assert_equal 'batatas', a.content.klass
  end

  def test_is_empty
    ObjectifyHash::NULLABLE_KEYS.clear
    h = ObjectifyHash::GenericObject.new({})
    assert h.empty?
  end

  def test_allows_top_level_constants
    h = {details: {files: [{name:'file A'}]}, process: '31B'}
    o = ObjectifyHash::GenericObject.new(h)
    assert_equal( {name:'file A'},  o.details.files.first.to_h)
    assert_equal '31B',  o.process
    #caviat
    assert o.details.files.first.is_a? ObjectifyHash::GenericObject::File_
  end

end