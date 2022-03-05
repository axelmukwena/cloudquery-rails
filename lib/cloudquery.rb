require 'ffi'
require 'json'

# Module that represents shared lib
module Cloudquery
  extend FFI::Library

  ffi_lib File.dirname(__FILE__) + '/cloudquery.so'

  # define class String to map:
  # C type struct { const char *p; GoInt n; }
  # There's some bug exchanging string values between rails and go
  class String < FFI::Struct
    layout :p,     :pointer,
           :len,   :long_long
    def initialize(str)
      self[:p] = FFI::MemoryPointer.from_string(str)
      self[:len] = str.bytesize
      self
    end
  end

  # foreign function definitions

  # ----------------- AWS -----------------
  attach_function :QueryAWS,
                  [String.by_value],
                  :int

  def aws(aws_json)
    json_string = JSON.generate(aws_json)
    c_string = Cloudquery::String.new(json_string)
    Cloudquery.QueryAWS(c_string)
  end

  # ----------------- GCP -----------------
  attach_function :QueryGCP,
                  [String.by_value],
                  :int

  def gcp(json_string)
    c_string = Cloudquery::String.new(json_string)
    Cloudquery.QueryGCP(c_string)
  end

  # module functions
  module_function :aws, :gcp

end