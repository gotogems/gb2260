namespace :gb2260 do
  task :divisions do
    Rake::Task['gb2260:provinces'].invoke

    csv_data('db/provinces.csv').each do |code, name|
      begin
        puts "#{code}: #{name}"
        Rake::Task['gb2260:prefectures'].execute(
          Rake::TaskArguments.new([:code], [code])
        )
      rescue Faraday::TimeoutError
        sleep 5
        retry
      end
    end

    csv_data('db/prefectures.csv').each do |code, name|
      begin
        puts "#{code}: #{name}"
        Rake::Task['gb2260:counties'].execute(
          Rake::TaskArguments.new([:code], [code])
        )
      rescue Faraday::TimeoutError
        sleep 5
        retry
      end
    end
  end
end
