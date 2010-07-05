dir = File.dirname(__FILE__)
file = File.basename(__FILE__, '.rb')
Dir.glob("#{dir}/#{file}/*.rb") do |filename|
  require "#{file}/#{File.basename(filename, '.rb')}"
end
