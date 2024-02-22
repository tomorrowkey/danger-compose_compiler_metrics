# frozen_string_literal: true

require "json"

class Metrics
  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def keys
    to_h.keys
  end

  def grouping_keys
    keys.map { |key| grouping_key(key) }.uniq
  end

  def grouped_metrics
    hash.
      group_by { |k, _| grouping_key(k) }.
      transform_values { |array| Metrics.new(array.to_h) }
  end

  def to_h
    hash
  end

  def respond_to_missing?(method_name, include_private)
    hash.key?(method_name.to_s) || hash.key?(convert_to_metrics_key(method_name)) || super
  end

  def method_missing(method_name)
    return hash[method_name.to_s] if hash.key?(method_name.to_s)

    key = convert_to_metrics_key(method_name)
    return hash[key] if hash.key?(key)

    super method_name
  end

  def self.load(path)
    Loader.new(path).load
  end

  def ==(other)
    hash == other.hash
  end

  class Loader
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def metrics_hash
      @metrics_hash ||= JSON.parse(File.read(path))
    end

    def load
      advanced_metrics_hash = metrics_hash.each.with_object({}) do |(k, v), h|
        h[k] = v

        case k
        when "skippableComposables"
          h["unskippableComposables"] = metrics_hash["totalComposables"] - metrics_hash["skippableComposables"]
        when "restartableComposables"
          h["unrestartableComposables"] = metrics_hash["totalComposables"] - metrics_hash["restartableComposables"]
        end
      end

      Metrics.new(advanced_metrics_hash)
    end
  end

  private

  def grouping_key(key)
    to_snake_case(key).split("_").last.capitalize
  end

  def to_small_camel_case(str)
    str.to_s.split("_").each_with_index.map { |s, i| i.zero? ? s : s.capitalize }.join
  end
  alias convert_to_metrics_key to_small_camel_case

  def to_snake_case(str)
    str.gsub(/::/, "/")
      .gsub(/([A-Z]+)([A-Z][a-z])/, "\\1_\\2")
      .gsub(/([a-z\d])([A-Z])/, "\\1_\\2")
      .tr("-", "_")
      .downcase
  end
end
