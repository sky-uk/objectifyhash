require 'test/unit'
require 'json'
require_relative File.join('..', 'lib', 'objectifyhash')
require_relative File.join('..', 'lib', 'objectifyhash', 'hash')

class A
  include ObjectifyHash

  ObjectifyHash::EXCEPTIONS.merge!({duration: Proc.new do
    100;
  end})
  ObjectifyHash::NULLABLE_KEYS.concat [:type]
end

class MyTest < Test::Unit::TestCase

  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  def test_compare_two_object_equals_objects
    json        = '{ "content": { "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0", "totalLicenses": 10 }}'
    hash        = JSON.parse json
    hash_object = A.new
    hash_object.convert_and_define (hash)

    equal_json        = '{ "content": { "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0", "totalLicenses": 10 }}'
    equal_hash        = JSON.parse equal_json
    equal_hash_object = A.new
    equal_hash_object.convert_and_define (hash)

    assert_equal hash_object, equal_hash_object
  end

  def test_compare_object_with_something_different_Hash_should_return_false
    json        = '{ "content": { "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0", "totalLicenses": 10 }}'
    hash        = JSON.parse json
    hash_object = A.new
    hash_object.convert_and_define (hash)

    some_string = 'String'

    assert_not_equal hash_object, some_string
  end

  def test_compare_different_ObjectifyHash_objects_should_return_false
    json        = '{ "content": { "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0", "totalLicenses": 10 }}'
    hash        = JSON.parse json
    hash_object = A.new
    hash_object.convert_and_define (hash)

    different_json        = '{ "content": { "assetId": "different", "totalLicenses": 999999 }}'
    different_hash        = JSON.parse different_json
    different_hash_object = A.new
    different_hash_object.convert_and_define (different_hash)

    assert_not_equal hash_object, different_hash_object
  end

  def test_compare_equal_ObjectifyHash_objects_tree_should_return_true
    json        = '{ "content": { "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0", "totalLicenses": 10, "asset": { "duration":1 } }}'
    hash        = JSON.parse json
    hash_object = A.new
    hash_object.convert_and_define (hash)

    different_json        =  '{ "totalLicenses": 10,"content": { "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0",  "asset": { "duration":1 } }}'
    different_hash        = JSON.parse different_json
    different_hash_object = A.new
    different_hash_object.convert_and_define (different_hash)

    assert_equal hash_object.content.asset, different_hash_object.content.asset
  end

  def test_compare_ObjectifyHash_objects_with_different_tree_should_return_false
    json        = '{ "content": { "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0", "totalLicenses": 10, "asset": { "duration":1 } }}'
    hash        = JSON.parse json
    hash_object = A.new
    hash_object.convert_and_define (hash)

    different_json        =  '{ "content": { "assetId": "e473a2f7-dc12-42d3-9933-fd5bd67a32e0", "totalLicenses": 10, "asset": { "duration":99999 } }}'
    different_hash        = JSON.parse different_json
    different_hash_object = A.new
    different_hash_object.convert_and_define (different_hash)

    assert_not_equal hash_object.content.asset, different_hash_object.content.asset
  end

end