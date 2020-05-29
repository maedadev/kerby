require 'erb'
require 'fileutils'
require 'json'
require 'kerby'
require 'securerandom'
require 'pathname'
require 'thor'
require 'yaml'

module Kerby
  class Cli < Thor
    class << self
      def exit_on_failure?
        true
      end
    end

    desc 'build <SRC-MANIFEST>...', 'build manifest from src and generate to STDOUT'
    option :node_yaml,  type: :string, aliases: ['-y']
    def build(*src_manifests)
      load_k8s_node(options[:node_yaml])
      temp_name  = sprintf("/tmp/kerby-%s-%s.yml",
                           Time.now.strftime("%Y%m%d-%H%M%S"),
                           SecureRandom.alphanumeric(8).downcase)
      t = File.open(temp_name, 'w')
      for src_manifest in src_manifests do
        saved_file = @_curr_file; @_curr_file = src_manifest
        File.write(t.path, ERB.new(File.read(src_manifest)).result(binding))
      end
      t.close

      File.open(temp_name) do |f|
        while s = f.gets do
          print s
        end
      end
      
      FileUtils.rm_f(temp_name)
      @_curr_file = saved_file
    end

    private

    # k8s include directive
    #
    # For example, <%= k8s_include('base/namespace') %> in manifest file will
    # include 'base/namespace.yml' file.
    #
    # The path is relative to the current (sometimes partial) manifest file.
    #
    # @!visibility public
    def k8s_include(path)
      ERB.new(File.read(Pathname(@_curr_file).dirname + (path + '.yml'))).result(binding)
    end

    def sys(command, dry_run)
      puts command
      return if dry_run
      fail unless system(command)
    end

    def load_k8s_node(node_yaml)
      if !node_yaml.nil?
        if File.exist?(node_yaml)
          @_k8s_node = YAML.load(ERB.new(File.read(node_yaml)).result)
          return
        else
          STDERR.printf("file doesn't exist: %s", node_yaml)
        end
      end
      @_k8s_node = {} if @_k8s_node.nil?
    end

    # return node_yaml value for the key.
    #
    # For example, command execution:
    #
    #   $ kerby build --node_yaml staging-node.yml manifest.yml
    #
    # and stageing-node.yml contains:
    #
    #   app:
    #     namespace:  city-A
    #
    # Then, <%= k8s_node('app.namespace') %> in manifest.yml will be
    # transformed to 'city-A'.
    #
    # @!visibility public
    def k8s_node(key)
      k8s_node_sub(@_k8s_node, key, key)
    end

    def k8s_node_sub(hash, key, prompt)
      keys = key.split('.')
      if key == keys[0]
        if hash[key].nil?
          ask(prompt + '? ')
        else
          hash[key]
        end
      else
        k8s_node_sub(hash[keys[0]] || {}, keys[1,keys.size-1].join('.'), prompt)
      end
    end

    # k8s_include with YAML indent
    #
    # @!visibility public
    def k8s_config_map(path)
      "|\n" +
      ERB.new(File.read(Pathname(@_curr_file).dirname + path)).result(binding).split("\n").map do |line|
        "        " + line + "\n"
      end.join('')
    end
  end
end
