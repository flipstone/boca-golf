class BocaGolf
  class Scorer
    def score(gist)
      if RUBY_VERSION >= "1.9"
        gist.code.length
      else
        gist.code.unpack("U*").length
      end
    end
  end
end
