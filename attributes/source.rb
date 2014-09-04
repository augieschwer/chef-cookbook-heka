#
# Cookbook Name:: heka
# Attribute:: source
#

default["heka"]["source"] = {
  "packages" => %w{ cmake mercurial git-core },
  "plugins" => [
    # Add items here like the following that's required for integration with kafka
    # "add_external_plugin(git https://github.com/innerr/heka-kafka 4cd1287b3ea19d0a04c807e9bed5a0cfb92cc805)"
  ],
  "git" => {
    "source" => "https://github.com/mozilla-services/heka.git",
  },
  "golang" => {
    "PATH" => [
      "/usr/local/go/bin",
      "/opt/go/bin"
    ],
    "packages" => [
      ## Add libraries required for plugins such as the the sarama library
      ## for communication with kafka
      # "github.com/Shopify/sarama"
    ]
  },
  "dir" => {
    "main" => "/usr/local/heka"
  }
}
