# frozen_string_literal: true

require "./lib/compose_compiler_metrics/metrics"
require "tempfile"

describe Metrics do
  let(:metrics) { described_class.new(hash) }

  let(:hash) do
    {
      "skippableComposables" => 5,
      "unskippableComposables" => 3,
      "restartableComposables" => 8,
      "unrestartableComposables" => 0,
      "readonlyComposables" => 0,
      "totalComposables" => 8,
      "restartGroups" => 8,
      "totalGroups" => 11,
      "staticArguments" => 5,
      "certainArguments" => 5,
      "knownStableArguments" => 50,
      "knownUnstableArguments" => 2,
      "unknownStableArguments" => 0,
      "totalArguments" => 52,
      "markedStableClasses" => 0,
      "inferredStableClasses" => 1,
      "inferredUnstableClasses" => 1,
      "inferredUncertainClasses" => 0,
      "effectivelyStableClasses" => 1,
      "totalClasses" => 2,
      "memoizedLambdas" => 4,
      "singletonLambdas" => 0,
      "singletonComposableLambdas" => 3,
      "composableLambdas" => 3,
      "totalLambdas" => 5
    }
  end

  describe "#keys" do
    subject { metrics.keys }

    it do
      is_expected.to eq %w(
        skippableComposables
        unskippableComposables
        restartableComposables
        unrestartableComposables
        readonlyComposables
        totalComposables
        restartGroups
        totalGroups
        staticArguments
        certainArguments
        knownStableArguments
        knownUnstableArguments
        unknownStableArguments
        totalArguments
        markedStableClasses
        inferredStableClasses
        inferredUnstableClasses
        inferredUncertainClasses
        effectivelyStableClasses
        totalClasses
        memoizedLambdas
        singletonLambdas
        singletonComposableLambdas
        composableLambdas
        totalLambdas
      )
    end
  end

  describe "#grouping_keys" do
    subject { metrics.grouping_keys }

    it { is_expected.to eq %w(Composables Groups Arguments Classes Lambdas) }
  end

  describe "#grouped_metrics" do
    subject { metrics.grouped_metrics }

    it do
      is_expected.to eq(
        "Composables" => described_class.new(
          "skippableComposables" => 5,
          "unskippableComposables" => 3,
          "restartableComposables" => 8,
          "unrestartableComposables" => 0,
          "readonlyComposables" => 0,
          "totalComposables" => 8
        ),
        "Groups" => described_class.new(
          "restartGroups" => 8,
          "totalGroups" => 11
        ),
        "Arguments" => described_class.new(
          "staticArguments" => 5,
          "certainArguments" => 5,
          "knownStableArguments" => 50,
          "knownUnstableArguments" => 2,
          "unknownStableArguments" => 0,
          "totalArguments" => 52
        ),
        "Classes" => described_class.new(
          "markedStableClasses" => 0,
          "inferredStableClasses" => 1,
          "inferredUnstableClasses" => 1,
          "inferredUncertainClasses" => 0,
          "effectivelyStableClasses" => 1,
          "totalClasses" => 2
        ),
        "Lambdas" => described_class.new(
          "memoizedLambdas" => 4,
          "singletonLambdas" => 0,
          "singletonComposableLambdas" => 3,
          "composableLambdas" => 3,
          "totalLambdas" => 5
        )
      )
    end
  end

  describe "#skippable_composables" do
    subject { metrics.skippable_composables }

    it { is_expected.to eq 5 }
  end

  describe "#unskippable_composables" do
    subject { metrics.unskippable_composables }

    it { is_expected.to eq 3 }
  end

  describe "#total_composables" do
    subject { metrics.total_composables }

    it { is_expected.to eq 8 }
  end

  describe "#to_h" do
    subject { metrics.to_h }

    it { is_expected.to eq metrics.hash }
  end
end

describe Metrics::Loader do
  let(:loader) { described_class.new(json_file.path) }

  let(:json_file) do
    Tempfile.create(["compose_compiler_metrics_", ".json"]).tap do |file|
      file.write(json)
      file.flush
    end
  end

  let(:json) do
    {
      "skippableComposables" => 5,
      "restartableComposables" => 8,
      "readonlyComposables" => 0,
      "totalComposables" => 8,
      "restartGroups" => 8,
      "totalGroups" => 11,
      "staticArguments" => 5,
      "certainArguments" => 5,
      "knownStableArguments" => 50,
      "knownUnstableArguments" => 2,
      "unknownStableArguments" => 0,
      "totalArguments" => 52,
      "markedStableClasses" => 0,
      "inferredStableClasses" => 1,
      "inferredUnstableClasses" => 1,
      "inferredUncertainClasses" => 0,
      "effectivelyStableClasses" => 1,
      "totalClasses" => 2,
      "memoizedLambdas" => 4,
      "singletonLambdas" => 0,
      "singletonComposableLambdas" => 3,
      "composableLambdas" => 3,
      "totalLambdas" => 5
    }.to_json
  end

  describe "#load" do
    subject { loader.load }

    it do
      is_expected.to have_attributes(
        skippable_composables: 5,
        restartable_composables: 8,
        readonly_composables: 0,
        total_composables: 8,
        restart_groups: 8,
        total_groups: 11,
        static_arguments: 5,
        certain_arguments: 5,
        known_stable_arguments: 50,
        known_unstable_arguments: 2,
        unknown_stable_arguments: 0,
        total_arguments: 52,
        marked_stable_classes: 0,
        inferred_stable_classes: 1,
        inferred_unstable_classes: 1,
        inferred_uncertain_classes: 0,
        effectively_stable_classes: 1,
        total_classes: 2,
        memoized_lambdas: 4,
        singleton_lambdas: 0,
        singleton_composable_lambdas: 3,
        composable_lambdas: 3,
        total_lambdas: 5
      )
    end

    it { is_expected.to have_attributes(unskippableComposables: 3) }
    it { is_expected.to have_attributes(unrestartableComposables: 0) }
  end
end
