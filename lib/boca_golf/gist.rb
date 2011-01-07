class BocaGolf
  class Gist
    attr_reader :code

    URI_REGEXP = URI.regexp(['http', 'https', 'ftp'])

    def self.load_from_location(location)
      if location =~ URI_REGEXP
        load_from_url location
      else
        load_from_file location
      end
    end

    def self.load_from_url(gist_url)
      new URI.parse(gist_url + ".txt").read
    end

    def self.load_from_file(file)
      new File.read(file)
    end

    def initialize(code)
      @code = code
    end

    def safe_module
      Module.new.tap do |m|
        m.send :include, insecure_module
        m.send :include, proxy_module(insecure_module)
      end
    end

    protected

    def insecure_module
      -> do
        $SAFE = 4
        Module.new.tap do |m|
          m.module_eval code
        end
      end.call
    end

    def proxy_module(mod)
      Module.new.tap do |proxy|
        mod.instance_methods.each do |method|
          proxy.module_eval %{
            def #{method}(*args, &block)
              -> do
                $SAFE = 4
                super
              end.call
            end
          }
        end
      end
    end
  end
end
