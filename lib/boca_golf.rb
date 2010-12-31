require 'boca_golf/checker'
require 'boca_golf/command_line'
require 'boca_golf/gist'
require 'boca_golf/result'
require 'boca_golf/scorer'

class BocaGolf
  def run(args, stdout, stderr)
    gist_url, *rspec_args = args
    gist   = Gist.load_from_url(gist_url)
    passed = Checker.new.run gist, rspec_args, stdout, stderr
    score  = Scorer.new.score gist

    Result.new gist, passed, score
  end
end
