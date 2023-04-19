
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

define_target "executor-lldb" do |target|
	target.priority = 0
	
	target.provides :executor => "Executor/lldb"
	
	target.provides "Executor/lldb" do
		define Rule, "run.executable-with-lldb" do
			input :executable_file
			
			parameter :prefix, implicit: true do |arguments|
				arguments[:prefix] ||= File.dirname(arguments[:executable_file])
			end
			
			parameter :arguments, optional: true
			
			apply do |parameters|
				run!(
					"lldb",
					"--source", File.expand_path("lldb/start", __dir__),
					"--source-on-crash", File.expand_path("lldb/crash", __dir__),
					parameters[:executable_file],
					"--",
					*parameters[:arguments],
					chdir: parameters[:prefix],
					foreground: true
				)
			end
		end
	end
end
