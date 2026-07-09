require "nokogiri"
require "pg"

app = ->(env) {
  body = env["PATH_INFO"] == "/up" ? "ok\n" : "ruby-bp-native-gem up (nokogiri #{Nokogiri::VERSION}, pg #{PG::VERSION})\n"
  [200, { "content-type" => "text/plain" }, [body]]
}
run app
