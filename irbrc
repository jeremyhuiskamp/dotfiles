# somewhat copied from /etc/irbrc
# Some default enhancements/settings for IRB, based on
# http://wiki.rubygarden.org/Ruby/page/show/Irb/TipsAndTricks
unless defined? HOME_IRBRC_LOADED
  # Taken from the pick-axe book
  # This allows one to view documentation inside rb
  def ri(*names)
    system(%{ri #{names.map {|name| name.to_s}.join(" ")}})
  end

  # kinda like the shell command ls
  def ls(arg='*')
      Dir[arg]
  end

  require 'fileutils'

  # like shell cd
  def cd(dest)
      FileUtils.cd dest
  end

  def pwd()
      Dir.pwd
  end

  IRB.conf[:AUTO_INDENT] = true

  # Require RubyGems by default.
  require 'rubygems'
  
  # Activate auto-completion.
  require 'irb/completion'

  # pretty print
  require 'pp'

  require 'method_info'
  
  # Setup permanent history.
  HISTFILE = "~/.irb_history"
  MAXHISTSIZE = 1000
  begin
    histfile = File::expand_path(HISTFILE)
    if File::exists?(histfile)
      lines = IO::readlines(histfile).collect { |line| line.chomp }
      puts "Read #{lines.nitems} saved history commands from '#{histfile}'." if $VERBOSE
      Readline::HISTORY.push(*lines)
    else
      puts "History file '#{histfile}' was empty or non-existant." if $VERBOSE
    end
    Kernel::at_exit do
      lines = Readline::HISTORY.to_a.reverse.uniq.reverse
      lines = lines[-MAXHISTSIZE, MAXHISTSIZE] if lines.nitems > MAXHISTSIZE
      puts "Saving #{lines.length} history lines to '#{histfile}'." if $VERBOSE
      File::open(histfile, File::WRONLY|File::CREAT|File::TRUNC) { |io| io.puts lines.join("\n") }
    end
  rescue => e
    puts "Error when configuring permanent history: #{e}" if $VERBOSE
  end

  HOME_IRBRC_LOADED=true
end
