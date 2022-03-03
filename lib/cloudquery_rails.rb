# frozen_string_literal: true

require_relative "cloudquery/version"
require 'ffi'

module CloudqueryRails
  class Error < StandardError; end
  # Your code goes here...

  extend FFI::Library
  puts "Here: " + File.dirname(__FILE__) + " | and | " + '/cloudquery.so'
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
  attach_function :QueryAWS,
                  [String.by_value, String.by_value],
                  :int

end
