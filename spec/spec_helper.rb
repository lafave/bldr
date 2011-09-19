require 'rubygems'
require 'rspec'

require 'yajl'
require 'tilt'

$:.unshift(File.dirname(File.expand_path(__FILE__)))

require File.join(File.dirname(File.expand_path(__FILE__)), "..", "lib", "bldr")

Dir['spec/models/*'].each { |f| require File.expand_path(f) }

RSpec.configure do |c|
  def node_wrap(*args, &block)
    Bldr::Node.new(*args, &block)
  end

  # Parse some json and return a ruby object
  def parse_json(str)
    Yajl::Parser.parse(str)
  end

  # Jsonify a ruby object
  def jsonify(hash)
    Yajl::Encoder.encode(hash)
  end

  # render the String template and compare to the jsonified hash
  def it_renders_template_to_hash(template,hash)
    tpl  = Bldr::Template.new {template}
    result = tpl.render(Bldr::Node.new)
    result.should == jsonify(hash)
  end

  c.after do
    Bldr.handlers.clear
  end


end
