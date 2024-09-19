# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

describe Danger::DangerComposeCompilerMetrics do
  let(:dangerfile) { testing_dangerfile }
  let(:plugin) { dangerfile.compose_compiler_metrics }

  describe "#new" do
    subject { plugin }

    it { is_expected.to be_a Danger::Plugin }
  end

  describe "#report_difference" do
    subject { plugin.report_difference(metrics_path, reference_metrics_path, options, build_variant_names) }

    let(:file_timestamp) { Time.new(2024, 1, 1, 0, 0, 0) }
    let(:metrics_path) { "#{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics" }
    let(:reference_metrics_path) { "#{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_baseline" }
    let(:options) { {} }
    let(:build_variant_names) { nil }

    before do
      [
        metrics_path,
        reference_metrics_path
      ].each do |dir|
        Dir.glob("#{dir}/*").each do |file|
          FileUtils.touch(file, mtime: file_timestamp)
        end
      end
    end

    let(:expect_report_list) do
      [
        "# Compose Compiler Metrics Difference Report",
        "## app - debug",
        <<~MARKDOWN,
        <details >
        <summary>

        ### Metrics Summary

        </summary>

        #### Composables

        | name | reference | new | diff |
        | --- | --- | --- | --- |
        | skippableComposables | 5 | 6 | +1 |
        | unskippableComposables | 3 | 1 | -2 |
        | restartableComposables | 8 | 7 | -1 |
        | unrestartableComposables | 0 | 0 |  |
        | readonlyComposables | 0 | 0 |  |
        | totalComposables | 8 | 7 | -1 |

        #### Groups

        | name | reference | new | diff |
        | --- | --- | --- | --- |
        | restartGroups | 8 | 7 | -1 |
        | totalGroups | 11 | 7 | -4 |

        #### Arguments

        | name | reference | new | diff |
        | --- | --- | --- | --- |
        | staticArguments | 5 | 4 | -1 |
        | certainArguments | 5 | 4 | -1 |
        | knownStableArguments | 50 | 47 | -3 |
        | knownUnstableArguments | 2 | 0 | -2 |
        | unknownStableArguments | 0 | 0 |  |
        | totalArguments | 52 | 47 | -5 |

        #### Classes

        | name | reference | new | diff |
        | --- | --- | --- | --- |
        | markedStableClasses | 0 | 0 |  |
        | inferredStableClasses | 1 | 2 | +1 |
        | inferredUnstableClasses | 1 | 0 | -1 |
        | inferredUncertainClasses | 0 | 0 |  |
        | effectivelyStableClasses | 1 | 2 | +1 |
        | totalClasses | 2 | 2 |  |

        #### Lambdas

        | name | reference | new | diff |
        | --- | --- | --- | --- |
        | memoizedLambdas | 4 | 4 |  |
        | singletonLambdas | 0 | 0 |  |
        | singletonComposableLambdas | 3 | 3 |  |
        | composableLambdas | 3 | 3 |  |
        | totalLambdas | 5 | 4 | -1 |

        </details>
        MARKDOWN
        <<~MARKDOWN,
        <details >
        <summary>

        ### Metrics

        </summary>

        ```diff
        --- #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_baseline/app_debug-module.json	#{file_timestamp.strftime('%F %T.%N %z')}
        +++ #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_debug-module.json	#{file_timestamp.strftime('%F %T.%N %z')}
        @@ -1,25 +1,25 @@
         {
        - "skippableComposables": 5,
        - "restartableComposables": 8,
        + "skippableComposables": 6,
        + "restartableComposables": 7,
          "readonlyComposables": 0,
        - "totalComposables": 8,
        - "restartGroups": 8,
        - "totalGroups": 11,
        - "staticArguments": 5,
        - "certainArguments": 5,
        - "knownStableArguments": 50,
        - "knownUnstableArguments": 2,
        + "totalComposables": 7,
        + "restartGroups": 7,
        + "totalGroups": 7,
        + "staticArguments": 4,
        + "certainArguments": 4,
        + "knownStableArguments": 47,
        + "knownUnstableArguments": 0,
          "unknownStableArguments": 0,
        - "totalArguments": 52,
        + "totalArguments": 47,
          "markedStableClasses": 0,
        - "inferredStableClasses": 1,
        - "inferredUnstableClasses": 1,
        + "inferredStableClasses": 2,
        + "inferredUnstableClasses": 0,
          "inferredUncertainClasses": 0,
        - "effectivelyStableClasses": 1,
        + "effectivelyStableClasses": 2,
          "totalClasses": 2,
          "memoizedLambdas": 4,
          "singletonLambdas": 0,
          "singletonComposableLambdas": 3,
          "composableLambdas": 3,
        - "totalLambdas": 5
        + "totalLambdas": 4
         }
        \\ No newline at end of file

        ```


        </details>
        MARKDOWN
        <<~MARKDOWN,
        <details >
        <summary>

        ### Composable Stats Report

        </summary>

        ```diff
        --- #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_baseline/app_debug-composables.csv	#{file_timestamp.strftime('%F %T.%N %z')}
        +++ #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_debug-composables.csv	#{file_timestamp.strftime('%F %T.%N %z')}
        @@ -1,5 +1,4 @@
         package,name,composable,skippable,restartable,readonly,inline,isLambda,hasDefaults,defaultsGroup,groups,calls,
        -com.example.android.ContactRow,ContactRow,1,0,1,0,0,0,0,0,1,2,
        +com.example.android.ContactRow,ContactRow,1,1,1,0,0,0,0,0,1,2,
         com.example.android.ToggleButton,ToggleButton,1,1,1,0,0,0,0,0,1,1,
        -com.example.android.ContactDetails,ContactDetails,1,0,1,0,0,0,0,0,1,1,
        -com.example.android.ui.theme.ExampleTheme,ExampleTheme,1,1,1,0,0,0,1,0,4,5,
        +com.example.android.ContactDetails,ContactDetails,1,1,1,0,0,0,0,0,1,1,

        ```


        </details>
        MARKDOWN
        <<~MARKDOWN,
        <details >
        <summary>

        ### Composable Report

        </summary>

        ```diff
        --- #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_baseline/app_debug-composables.txt	#{file_timestamp.strftime('%F %T.%N %z')}
        +++ #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_debug-composables.txt	#{file_timestamp.strftime('%F %T.%N %z')}
        @@ -1,16 +1,11 @@
        -restartable scheme("[androidx.compose.ui.UiComposable]") fun ContactRow(
        -  unstable contact: Contact
        +restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun ContactRow(
        +  stable contact: Contact
           stable modifier: Modifier? = @static Companion
         )
         restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun ToggleButton(
           stable selected: Boolean
           stable onToggled: Function1<Boolean, Unit>
         )
        -restartable scheme("[androidx.compose.ui.UiComposable]") fun ContactDetails(
        -  unstable contact: Contact
        -)
        -restartable skippable scheme("[0, [0]]") fun ExampleTheme(
        -  stable darkTheme: Boolean = @dynamic isSystemInDarkTheme($composer, 0)
        -  stable dynamicColor: Boolean = @static true
        -  stable content: Function2<Composer, Int, Unit>
        +restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun ContactDetails(
        +  stable contact: Contact
         )

        ```


        </details>
        MARKDOWN
        <<~MARKDOWN
        <details >
        <summary>

        ### Class Report

        </summary>

        ```diff
        --- #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_baseline/app_debug-classes.txt	#{file_timestamp.strftime('%F %T.%N %z')}
        +++ #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_debug-classes.txt	#{file_timestamp.strftime('%F %T.%N %z')}
        @@ -1,8 +1,8 @@
         stable class MainActivity {
           <runtime stability> = Stable
         }
        -unstable class Contact {
        -  stable var name: String
        +stable class Contact {
        +  stable val name: String
           stable val number: String
        -  <runtime stability> = Unstable
        +  <runtime stability> = Stable
         }

        ```


        </details>
        MARKDOWN
      ]
    end

    it "output markdown summary" do
      subject

      dangerfile.status_report[:markdowns].map(&:message).each_with_index do |message, index|
        expect(message).to eq(expect_report_list[index])
      end
    end

    context "when missing diff command" do
      before do
        allow_any_instance_of(Helper).to receive(:installed?).with("diff").and_return(false)
      end

      it do
        within_block_is_expected.to change {
          dangerfile.status_report[:errors]
        }.from(
          be_empty
        ).to(
          ["diff command not found. Please install diff command."]
        )
      end
    end

    context "when missing reference metrics file" do
      let(:reference_metrics_path) { "#{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_missing" }

      it do
        within_block_is_expected.to change {
          dangerfile.status_report[:warnings]
        }.from(
          be_empty
        ).to(
          [
            "DangerComposeCompilerMetrics: reference file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_missing/app_debug-module.json. Skipping file difference report.",
            "DangerComposeCompilerMetrics: reference file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_missing/app_debug-module.json. Skipping file difference report.",
            "DangerComposeCompilerMetrics: reference file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_missing/app_debug-composables.csv. Skipping file difference report.",
            "DangerComposeCompilerMetrics: reference file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_missing/app_debug-composables.txt. Skipping file difference report.",
            "DangerComposeCompilerMetrics: reference file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics_missing/app_debug-classes.txt. Skipping file difference report."
          ]
        )
      end
    end

    context "when metrics option is disabled" do
      let(:options) { { metrics: :disabled } }

      it do
        within_block_is_expected.to change {
          dangerfile.status_report[:markdowns].map(&:message)
        }.from(
          be_empty
        ).to(
          expect_report_list.reject.with_index { |_, i| i == 3 }
        )
      end
    end

    context "when metrics option is open" do
      let(:options) { { metrics: :open } }

      it do
        subject

        expect(dangerfile.status_report[:markdowns][3].message).to eq(
          expect_report_list[3].gsub("<details >", "<details open>")
        )
      end
    end

    context "when build_variant_names is [[app, debug]]" do
      let(:build_variant_names) { [["app", "debug"]] }

      it do
        subject

        dangerfile.status_report[:markdowns].map(&:message).each_with_index do |message, index|
          expect(message).to eq(expect_report_list[index])
        end
      end
    end

    context "when build_variant_names is [[app, release]] that does not exists" do
      let(:build_variant_names) { [["app", "release"]] }

      it "reports missing report files" do
        subject

        expect(dangerfile.status_report[:warnings]).to eq(
          [
            "DangerComposeCompilerMetrics: new file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_release-module.json. Skipping file difference report.",
            "DangerComposeCompilerMetrics: new file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_release-module.json. Skipping file difference report.",
            "DangerComposeCompilerMetrics: new file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_release-composables.csv. Skipping file difference report.",
            "DangerComposeCompilerMetrics: new file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_release-composables.txt. Skipping file difference report.",
            "DangerComposeCompilerMetrics: new file not found at #{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics/app_release-classes.txt. Skipping file difference report.",
          ]
        )
      end
    end
  end

  describe "#report" do
    subject { plugin.report(metrics_path, options) }

    let(:metrics_path) { "#{File.dirname(__FILE__)}/support/fixtures/compose_compiler_metrics" }
    let(:options) { {} }
    let(:expect_report_list) do
      [
        "# Compose Compiler Metrics Report",
        "## app - debug",
        <<~MARKDOWN,
        <details >
        <summary>

        ### Metrics

        </summary>

        | name | value |
        | --- | --- |
        | skippableComposables | 6 |
        | restartableComposables | 7 |
        | readonlyComposables | 0 |
        | totalComposables | 7 |
        | restartGroups | 7 |
        | totalGroups | 7 |
        | staticArguments | 4 |
        | certainArguments | 4 |
        | knownStableArguments | 47 |
        | knownUnstableArguments | 0 |
        | unknownStableArguments | 0 |
        | totalArguments | 47 |
        | markedStableClasses | 0 |
        | inferredStableClasses | 2 |
        | inferredUnstableClasses | 0 |
        | inferredUncertainClasses | 0 |
        | effectivelyStableClasses | 2 |
        | totalClasses | 2 |
        | memoizedLambdas | 4 |
        | singletonLambdas | 0 |
        | singletonComposableLambdas | 3 |
        | composableLambdas | 3 |
        | totalLambdas | 4 |

        </details>
        MARKDOWN
        <<~MARKDOWN,
        <details >
        <summary>

        ### Composable Stats Report

        </summary>

        | package | name | composable | skippable | restartable | readonly | inline | isLambda | hasDefaults | defaultsGroup | groups | calls |  |
        | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
        | com.example.android.ContactRow | ContactRow | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 2 |  |
        | com.example.android.ToggleButton | ToggleButton | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |  |
        | com.example.android.ContactDetails | ContactDetails | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |  |

        </details>
        MARKDOWN
        <<~MARKDOWN,
        <details >
        <summary>

        ### Composable Report

        </summary>

        ```kotlin
        restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun ContactRow(
          stable contact: Contact
          stable modifier: Modifier? = @static Companion
        )
        restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun ToggleButton(
          stable selected: Boolean
          stable onToggled: Function1<Boolean, Unit>
        )
        restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun ContactDetails(
          stable contact: Contact
        )

        ```


        </details>
        MARKDOWN
        <<~MARKDOWN
        <details >
        <summary>

        ### Class Report

        </summary>

        ```kotlin
        stable class MainActivity {
          <runtime stability> = Stable
        }
        stable class Contact {
          stable val name: String
          stable val number: String
          <runtime stability> = Stable
        }

        ```


        </details>
        MARKDOWN
      ]
    end

    it do
      within_block_is_expected.to change {
        dangerfile.status_report[:markdowns].map(&:message)
      }.from(
        be_empty
      ).to(
        expect_report_list
      )
    end

    context "when metrics option is disabled" do
      let(:options) { { metrics: :disabled } }

      it do
        within_block_is_expected.to change {
          dangerfile.status_report[:markdowns].map(&:message)
        }.from(
          be_empty
        ).to(
          expect_report_list.reject.with_index { |_, i| i == 2 }
        )
      end
    end

    context "when metrics option is open" do
      let(:options) { { metrics: :open } }

      it do
        subject

        expect(dangerfile.status_report[:markdowns][2].message).to eq(
          expect_report_list[2].gsub("<details >", "<details open>")
        )
      end
    end
  end
end
