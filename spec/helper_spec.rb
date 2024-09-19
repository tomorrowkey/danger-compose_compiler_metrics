# frozen_string_literal: true

require "spec_helper"
require "./lib/compose_compiler_metrics/helper"

describe "Helper" do
  include Helper

  describe "#build_variants" do
    subject { build_variants(dir) }

    let(:dir) { Dir.mktmpdir }

    before do
      build_variants_names.each do |build_variants_name|
        FileUtils.touch("#{dir}/#{module_name}_#{build_variants_name}-classes.txt")
        FileUtils.touch("#{dir}/#{module_name}_#{build_variants_name}-composables.csv")
        FileUtils.touch("#{dir}/#{module_name}_#{build_variants_name}-composables.txt")
        FileUtils.touch("#{dir}/#{module_name}_#{build_variants_name}-module.json")
      end
    end

    after do
      FileUtils.rm_rf(dir)
    end

    context "when module name is app" do
      let(:module_name) { "app" }

      context "when build_variants is debug" do
        let(:build_variants_names) { ["debug"] }

        it { is_expected.to eq([["app", "debug"]]) }
      end

      context "when build_variants are debug and release" do
        let(:build_variants_names) { ["debug", "release"] }

        it { is_expected.to eq([["app", "debug"], ["app", "release"]]) }
      end

      context "when build_variants is debugProduction" do
        let(:build_variants_names) { ["debugProduction"] }

        it { is_expected.to eq([["app", "debugProduction"]]) }
      end
    end

    context "when module name is app-core" do
      let(:module_name) { "app-core" }

      context "when build_variants is debug" do
        let(:build_variants_names) { ["debug"] }

        it { is_expected.to eq([["app-core", "debug"]]) }
      end

      context "when build_variants is debugProduction" do
        let(:build_variants_names) { ["debugProduction"] }

        it { is_expected.to eq([["app-core", "debugProduction"]]) }
      end
    end
  end
end
