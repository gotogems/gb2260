namespace :gb2260 do
  include GB2260::Utils

  task :provinces => 'fetch:provinces'
  task :prefectures do
    provinces_hash.each do |code, name|
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
    prefectures_hash.each do |code, name|
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
    counties_hash.each do |code, name|
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
  end

  def provinces_hash
    load_file('db/provinces.csv').to_h
  end

  def prefectures_hash
    load_file('db/prefectures.csv').to_h
  end

  def counties_hash
    load_file('db/counties.csv').to_h
  end

  def info(*args)
    puts '✅ %s %s' % args
  end
end
