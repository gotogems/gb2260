namespace :gb2260 do
  task :provinces => 'fetch:provinces'
  task :prefectures do
    provinces_hash.each do |code, name|
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
  end

  task :counties do
    prefectures_hash.each do |code, name|
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

  task :townships do
  end

  task :divisions do
  end

  def provinces_hash
    GB2260::Dataset.load_file('db/provinces.csv').to_h
  end

  def prefectures_hash
    GB2260::Dataset.load_file('db/prefectures.csv').to_h
  end

  def counties_hash
    GB2260::Dataset.load_file().to_h
  end
end
