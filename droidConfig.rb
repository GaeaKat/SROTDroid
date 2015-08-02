require 'singleton'
require 'yaml'
class DroidConfig
  include Singleton

  def initialize
    @config = YAML::load(IO.read('config/config.yml'))
  end
  def [](value)
    @config[value]
  end

end
