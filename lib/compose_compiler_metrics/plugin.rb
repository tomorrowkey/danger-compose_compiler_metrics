# frozen_string_literal: true

require "json"
require "csv"

require_relative "./helper"

module Danger
  class DangerComposeCompilerMetrics < Plugin
    include Helper

    def report_difference(metrics_dir, base_metrics_dir)
      unless installed?("diff")
        error "diff command not found. Please install diff command."
        return
      end

      markdown("# Compose Compiler Metrics Difference Report")
      build_variants(metrics_dir).each do |module_name, build_variant|
        markdown("## #{module_name} - #{build_variant}")

        # Metrics Report
        metrics_path = File.join(metrics_dir, metrics_filename(module_name, build_variant))
        base_metrics_path = File.join(base_metrics_dir, metrics_filename(module_name, build_variant))
        report_file_difference("Metrics", metrics_path, base_metrics_path)

        # Composable Stats Report
        composable_stats_report_path = File.join(metrics_dir, composable_stats_report_path(module_name, build_variant))
        base_composable_stats_report_path = File.join(base_metrics_dir, composable_stats_report_path(module_name, build_variant))
        report_file_difference("Composable Stats Report", composable_stats_report_path, base_composable_stats_report_path)

        # Composable Report
        composable_report_path = File.join(metrics_dir, composable_report_path(module_name, build_variant))
        base_composable_report_path = File.join(base_metrics_dir, composable_report_path(module_name, build_variant))
        report_file_difference("Composable Report", composable_report_path, base_composable_report_path)

        # Class Report
        class_report_path = File.join(metrics_dir, class_report_path(module_name, build_variant))
        base_class_report_path = File.join(base_metrics_dir, class_report_path(module_name, build_variant))
        report_file_difference("Composable Report", class_report_path, base_class_report_path)
      end
    end

    def report_file_difference(title, metrics_path, base_metrics_path)
      unless File.exist?(metrics_path)
        warn "DangerComposeCompilerMetrics: new file not found at #{metrics_path}. Skipping file difference report."
        return
      end

      unless File.exist?(base_metrics_path)
        warn "DangerComposeCompilerMetrics: reference file not found at #{base_metrics_path}. Skipping file difference report."
        return
      end

      report = `diff -u #{base_metrics_path} #{metrics_path}`

      markdown(
        folding(
          "### #{title}",
          if report.empty?
            "No difference found."
          else
            <<~MARKDOWN
            ```diff
            #{report}
            ```
            MARKDOWN
          end
        )
      )
    end

    def report(metrics_dir)
      markdown("# Compose Compiler Metrics Report")
      build_variants(metrics_dir).each do |module_name, build_variant|
        markdown("## #{module_name} - #{build_variant}")

        # Metrics Report
        metrics_path = File.join(metrics_dir, metrics_filename(module_name, build_variant))
        table_headers = %w[name value]
        table_rows = JSON.load_file(metrics_path).to_a

        markdown(
          folding(
            "### Metrics",
            build_markdown_table(table_headers, table_rows)
          )
        )

        # Composable Stats Report
        composable_stats_report_path = File.join(metrics_dir, composable_stats_report_path(module_name, build_variant))
        csv = CSV.read(composable_stats_report_path, headers: true)

        markdown(
          folding(
            "### Composable Stats Report",
            build_markdown_table(csv.headers, csv.map(&:fields))
          )
        )

        # Composable Report
        composable_report_path = File.join(metrics_dir, composable_report_path(module_name, build_variant))
        markdown(
          folding(
            "### Composable Report",
            <<~MARKDOWN
            ```kotlin
            #{File.read(composable_report_path)}
            ```
            MARKDOWN
          )
        )

        # Class Report
        class_report_path = File.join(metrics_dir, class_report_path(module_name, build_variant))
        markdown(
          folding(
            "### Class Report",
            <<~MARKDOWN
            ```kotlin
            #{File.read(class_report_path)}
            ```
            MARKDOWN
          )
        )
      end
    end
  end
end
