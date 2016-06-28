require 'test/unit'
require '../lib/persistence'

class PersistedDataFromFile

  attr_accessor :config
  include PersistedHashToObj

  def initialize(filename, file_dir)
    load(filename, file_dir:file_dir)   ## @config will be populated
    puts(@config)
  end
end



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

    ### Access by .hash_key
    hash_to_object_instance.config.api_root='http://%sskystore.com/API/'

    ### Access by [hash_key]
    hash_to_object_instance.config[:api_root]='https://%sskystore.com/API/'

    ### Add new key-val
    hash_to_object_instance.config[:something_new]='Something_New_Value'

    ### Add new value to an Existing LIST
    hash_to_object_instance.config[:full_boxsets].push('New_Boxset_In_List')

  end


  # Fake test
  def test_load_change_and_save

    yml = PersistedDataFromFile.new(filename='example.yml', file_dir='../test/config')
    test_steps(yml)                   ### Run test Scenarios
    #yml.save()                        ###
    filename = yml.get_output_file()

    yml = PersistedDataFromFile.new(filename='example.yml', file_dir='../test/config')
    puts(yml.config.to_h)
  end
end