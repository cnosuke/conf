alias :r :require

def l
  Pry.history.load
end

def r(name)
  require name.to_s
end

def rr
  %w[
    active_support/all
    parallel
    csv
  ].each do |e|
    printf("loading `#{e}`... ", e)
    begin
      r = require(e)
    rescue LoadError
      r = false
    end
    print (r ? "ok\n" : "load error\n")
  end

  return true
end

begin
  require "awesome_print"

  def pbcopy(str, opts = {})
    IO.popen('pbcopy', 'r+') { |io| io.print str }
  end

  Pry.config.commands.command "copy", "Copy last evaluated object to clipboard" do
    pbcopy _pry_.last_result.ai(:plain => true, :indent => 2, :index => false)
    output.puts "Copied!"
  end
rescue Exception
end

Pry.config.prompt = [
  proc {|target_self, nest_level, pry|
    nested = (nest_level.zero?) ? '' : ":#{nest_level}"
    "[#{pry.input_ring.size}] #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}(#{Pry.view_clip(target_self)})#{nested}> "
  },
  proc {|target_self, nest_level, pry|
    nested = (nest_level.zero?) ?  '' : ":#{nest_level}"
    if defined?(pry.input_array) then
      "[#{pry.input_array.size}] #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}(#{Pry.view_clip(target_self)})#{nested}* "
    else
      ""
    end
  }
]

local_pryrc_path = File.join(__dir__, 'pryrc.local.rb')
if File.exist?(local_pryrc_path)
  require local_pryrc_path
  include PryrcLocal
end
