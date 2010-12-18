class BocaGolf
  def run(args, stdout, stderr)
    gist_url, *rspec_args = args
    gist = Net::HTTP.get URI.parse(gist_url + ".txt")
    Kernel.module_eval gist
    Rspec::Core::Runner.run rspec_args, stderr, stdout
  end
end
