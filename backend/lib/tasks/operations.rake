namespace :operations do
  desc "Read-only configuration and payment health summary (no secrets or personal data)"
  task audit: :environment do
    report = OperationsSnapshot.call
    puts JSON.generate(report)
    exit 2 if report.fetch(:warnings).any?
  end

  desc "Dump and restore synthetic data in two disposable local test databases"
  task restore_drill: :environment do
    require_relative "../operations/restore_drill"
    puts JSON.generate(Operations::RestoreDrill.new.call)
  end
end
