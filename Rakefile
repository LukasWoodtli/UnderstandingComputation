require 'find'

task default: [:test]

task :test do
  this_dir = File.expand_path(File.dirname(__FILE__))
  Find.find(this_dir) do |path|
    if path.end_with? ".rb"
      if File.basename(path).start_with?("tc_")
        ruby "'#{path}'"
      end
    end
  end
end
