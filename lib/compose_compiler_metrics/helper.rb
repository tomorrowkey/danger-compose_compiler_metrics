# frozen_string_literal: true

module Helper
  def build_variants(dir)
    Dir.glob("#{dir}/*").
      map { |s| File.basename(s).split(/[_-]/).take(2) }.
      uniq
  end

  def metrics_filename(module_name, build_variant)
    "#{module_name}_#{build_variant}-module.json"
  end

  def composable_stats_report_path(module_name, build_variant)
    "#{module_name}_#{build_variant}-composables.csv"
  end

  def composable_report_path(module_name, build_variant)
    "#{module_name}_#{build_variant}-composables.txt"
  end

  def class_report_path(module_name, build_variant)
    "#{module_name}_#{build_variant}-classes.txt"
  end

  def build_markdown_table(headers, rows)
    [].tap do |table|
      table << "| #{headers.join(' | ')} |"
      table << "| #{headers.map { |h| '---' }.join(' | ')} |"
      rows.each do |row|
        table << "| #{row.join(' | ')} |"
      end
    end.join("\n")
  end

  def folding(summary, details, open)
    open_attribute = open == :open ? "open" : ""

    <<~HTML
    <details #{open_attribute}>
    <summary>

    #{summary}

    </summary>

    #{details}

    </details>
    HTML
  end

  def installed?(command)
    system("which #{command} > /dev/null")
  end
end
