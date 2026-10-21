namespace :questions do
  desc "Export question content only to an explicit new JSON file (read-only database access)"
  task export: :environment do
    report = QuestionArchive.export!(path: ENV["OUTPUT"])
    puts JSON.generate(report.merge(status: "ok", operation: "question_export"))
  rescue QuestionArchive::Error => error
    warn error.message
    exit 1
  rescue ActiveRecord::ActiveRecordError
    warn "問題の書き出しに失敗しました。DBの接続・設定を確認してください"
    exit 1
  end

  desc "Explicitly import a verified question archive into an empty questions database"
  task import: :environment do
    report = QuestionArchive.import!(path: ENV["INPUT"], confirmation: ENV["CONFIRM"])
    puts JSON.generate(report.merge(status: "ok", operation: "question_import"))
  rescue QuestionArchive::Error => error
    warn error.message
    exit 1
  rescue ActiveRecord::ActiveRecordError
    warn "問題の取り込みに失敗しました。DBの接続・設定を確認してください"
    exit 1
  end
end
