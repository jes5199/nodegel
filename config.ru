# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
require 'respace_url'
require 'noder_presence'
use RespaceUrl
use NoderPresence
run Rails.application
