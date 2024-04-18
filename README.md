danger-compose_compiler_metrics
===

A [danger](https://github.com/danger/danger) plugin for reporting [compose compiler metrics](https://github.com/androidx/androidx/blob/androidx-main/compose/compiler/design/compiler-metrics.md)

# Installation

```shell
gem install danger-compose_compiler_metrics
```

# Usage

## Reporting difference of compose compiler metrics

```ruby
Dir.glob('**/compose_compiler_metrics').each do |report_dir|
  next if report_dir.include?("vendor/bundle")

  compose_compiler_metrics.report_difference(report_dir, "#{report_dir}_baseline")
end

```

I recommend a use case that compare the metrics report in the feature branch with the metrics report in the main branch.
Following is example of implementation using Github Actions.

https://github.com/tomorrowkey/danger-compose_compiler_metrics-example/pull/1

## Reporting compose compiler metrics 

```ruby
Dir.glob('**/compose_compiler_metrics').each do |report_dir|
  next if report_dir.include?("vendor/bundle")

  compose_compiler_metrics.report(report_dir)
end
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
