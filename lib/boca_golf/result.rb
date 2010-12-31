class BocaGolf
  class Result < Struct.new(:gist, :passed, :score)
    def passed?
      passed
    end
  end
end
