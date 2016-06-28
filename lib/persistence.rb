require 'yaml'
require 'fileutils'
require_relative File.join('objectifyhash.rb')



def generate_random_filename(prefix='', filetype='yml')
  ## Generates a random filename,
  length = 3
  letters  = ('A'..'Z').to_a + ('a'..'z' ).to_a
  unique_key = letters.sample

  length.times do
    unique_key = unique_key + letters.sample
  end

  if prefix != ''
    new_filename = prefix+'__'+unique_key+".#{filetype}"
  else
    new_filename = unique_key+".#{filetype}"
  end

  return new_filename
end



module Persistence

  attr_accessor :config


  public


  def load(filename, random_filename: true, file_dir: '../config', allow_file_writting: true)
    ### This method, can be called, during initialization of the object that uses the Persistence itself.
    ### Persistence itself, will always be supported, just by importing it.
    ### The only thing that changes by using this load(filename), is that an initial state is SET into the object that uses it

    @original_filename  = filename            # base config filename
    @random_filename    = random_filename     # if true, will copy the base config as reference to a new random filename, which will be used.
    @allow_file_writing = allow_file_writting # if true, allows output file to be written
    @file_dir           = file_dir
    @complete_file_path = nil
    @filename = get_file_to_use!(prefix = @original_filename.split('.').first.split('_').first)       ### TODO: This is Automation Related Logic: nft_hhe.yml, that should NOT be here.

    puts("======= Reading from config: #{@original_filename} =======")
    load_config_file!(@original_filename)
  end

  def save(config:@config)          ## TODO Should we hide (set_output_file, and )
    if @__parent__ != nil
      @__parent__.save

    else
      init_if_needed!

      if @allow_file_writing
        puts("Saving in #{@complete_file_path}") if @debug
        File.open( @complete_file_path, 'w') do |f|
          val = self.to_h.to_yaml                       ## TODO , check if this work with HashToObject
          f.write val
        end
      else
        ## Let's just detect, that someone is trying to write into this file, and it should not (eg. Read Only config)
        ## This will allow to track & fix those cases faster
        puts("[PERSISTENCE] WARN: File has not been written!!! File Write is disabled for #{@filename}")
      end
    end
  end


  def set_output_file(filename, file_dir)
    @file_dir = file_dir
    @filename = filename
    @complete_file_path = File.join(@file_dir, @filename)           ## Output Filename
  end

  def get_output_file()
    return @filename
  end


  def get_class_to_create()
    return PersistedHashToObj
  end


  def get_root
    if @__parent__ == nil
      return self
    else
      return @__parent__.get_root
    end
  end

  private
  def init_if_needed!
    @file_dir   = ''
    @debug      = true

    ## Do we have any output file defined already?
    if @complete_file_path == nil
      @random_filename    = true
      @allow_file_writing = true
      get_file_to_use!(prefix='tmp')
    end


    ## TODO restore this later, for Initializations, that do not Load any file
   # if @config == nil
   #   @config = @config =  PersistedHashToObj.new({})
   # end

  end


  def get_file_to_use!(prefix = '')
    ### sets @filename And @complete_file_path

    if @file_dir == nil or @file_dir.strip() == ''
      @file_dir = File.join( File.dirname(__FILE__), '..', 'tmp')
      @random_filename = true
    end

    if @random_filename
      @filename   = generate_random_filename(prefix=prefix)
    else
      @filename   = @original_filename
    end


    @complete_original_file_path  = File.join(@original_filename, @filename) if @original_filename   ## Input Filename
    @complete_file_path           = set_output_file(@filename, @file_dir)


    return @filename
  end

  def load_config_file!(filename)
    loaded_yml = YAML.load_file( File.join(@file_dir, filename) )
    @config      = PersistedHashToObj.new(loaded_yml)
    return @config
  end
  public
end


class PersistedHashToObj < GenericObject
  include ObjectifyHash
  include Persistence
  attr_accessor :config

  def initialize hash={}, parent=nil
    super hash, parent=parent
  end



end