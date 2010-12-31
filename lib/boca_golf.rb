require 'boca_golf/checker'
require 'boca_golf/gist'

class BocaGolf
  def run(args, stdout, stderr)
    gist_url, *rspec_args = args

    Checker.new.run Gist.load_from_url(gist_url), rspec_args, stdout, stderr
  end
end
