namespace :build do
  include GB2260::Dataset::Utils

  task :provinces => 'fetch:provinces'
  task :prefectures do
    dataset('db/provinces.csv')
      .each do |code, name|
      begin
        Rake::Task['fetch:prefectures'].execute(
          Rake::TaskArguments.new([:code], [code])
        )
      rescue Faraday::TimeoutError
        sleep 5
        retry
      ensure
        info code, name
      end
    end
  end

  task :counties do
    dataset('db/prefectures.csv')
      .each do |code, name|
      begin
        Rake::Task['fetch:counties'].execute(
          Rake::TaskArguments.new([:code], [code])
        )
      rescue Faraday::TimeoutError
        sleep 5
        retry
      ensure
        info code, name
      end
    end
  end

  task :townships do
    dataset('db/counties.csv')
      .each do |code, name|
      begin
        Rake::Task['fetch:townships'].execute(
          Rake::TaskArguments.new([:code], [code])
        )
      rescue Faraday::TimeoutError
        sleep 5
        retry
      rescue Faraday::Error
        sleep 15
        retry
      ensure
        info code, name
      end
    end
  end

  task :divisions do
    puts JSON.pretty_generate(
      dataset('db/provinces.csv').merge(
        dataset('db/prefectures.csv').merge(
          dataset('db/counties.csv')
        )
      )
    )
  end

  def dataset(csv_file)
    load_file(csv_file).to_h
  end

  def info(*args)
    puts '✅ %s %s' % args
  end
end
