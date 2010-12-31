class BocaGolf
  class Gist
    attr_reader :code

    def self.load_from_url(gist_url)
      uri = URI.parse(gist_url + ".txt")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.start { new http.get(uri.to_s).body }
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
