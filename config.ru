# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
require 'respace_url'
use RespaceUrl
run Rails.application
