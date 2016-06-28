require 'test/unit'
require_relative File.join('..', 'lib', 'persistence.rb')


class PersistenceTest < Test::Unit::TestCase


  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_steps(hash_to_object_instance)

    ### Get by .has_key
    puts('api_root', hash_to_object_instance.config.api_root)



    hash_to_object_instance.config.test_info.property_a= 9191919191919
    hash_to_object_instance.config.some_url= 'www.batatas.com'
    ### Set by .hash_key
    hash_to_object_instance.config.api_root='http://%sskystore.com/API/'

    ### Set by [hash_key]
    #hash_to_object_instance.config[:api_root]='https://%sskystore.com/API/'

    ### Set new key-val
    #hash_to_object_instance.config[:something_new]='Something_New_Value'

    ### Set new value to an Existing LIST
    #hash_to_object_instance.config[:full_boxsets].push('New_Boxset_In_List')

  end


  # Fake test
  def test_load_change_and_save

    yml = PersistedHashToObj.new()
    ### Load pristine data, and modify it
    yml.load('example.yml', file_dir:'../test/config')
    test_steps(yml)                   ### Run test Scenarios


    #### Load Modified Data
    filename = yml.get_output_file()
    yml = PersistedHashToObj.new()
    yml.load(filename, file_dir:'../test/config')
    puts(yml.config.to_h)

    #### Check wanted changed
    #### TODO
  end
end