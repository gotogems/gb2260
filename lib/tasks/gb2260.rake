namespace :gb2260 do
  conn = Faraday.new(url: 'https://www.stats.gov.cn')

  task :provinces do
    response = conn.get('/sj/tjbz/tjyqhdmhcxhfdm/2023/')
    dataset = {}

    if response.success?
      doc = Nokogiri::HTML(response.body)
      doc.css('tr.provincetr td a').each do |link|
        code = link.attr(:href).match(/\d+/)[0]
        name = link.text.strip

        code << '0000'
        dataset[code] = name
      end

      output_string = generate_csv(dataset)
      output_file('db/provinces.csv', output_string)
    else
      puts response.body
    end
  end

  task :prefectures, [:code] do |t, args|
    args.with_defaults(code: '440000')
    province_n = args[:code][0, 2]
    response = conn.get("/sj/tjbz/tjyqhdmhcxhfdm/2023/#{province_n}.html")
    csv_file = 'db/prefectures.csv'
    dataset = csv_data(csv_file)

    if response.success?
      doc = Nokogiri::HTML(response.body)
      doc.css('tr.citytr').each do |row|
        code, name = row.css('td a').map(&:text)
        dataset[code[0, 6]] = name.strip
      end

      output_string = generate_csv(dataset)
      output_file(csv_file, output_string)
    else
      puts response.body
    end
  end

  task :counties, [:code] do |t, args|
    args.with_defaults(code: '445100')
    province_n = args[:code][0, 2]
    prefecture_n = args[:code][0, 4]
    response = conn.get("/sj/tjbz/tjyqhdmhcxhfdm/2023/#{province_n}/#{prefecture_n}.html")
    csv_file = 'db/counties.csv'
    dataset = csv_data(csv_file)

    if response.success?
      doc = Nokogiri::HTML(response.body)
      doc.css('tr.countytr').each do |row|
        code, name = row.css('td a').map(&:text)

        if code and name
          dataset[code[0, 6]] = name.strip
        end
      end

      output_string = generate_csv(dataset)
      output_file(csv_file, output_string)
    else
      puts response.body
    end
  end

  task :townships, [:code] do |t, args|
    args.with_defaults(code: '445103')
    province_n = args[:code][0, 2]
    prefecture_n = args[:code][2, 2]
    response = conn.get("/sj/tjbz/tjyqhdmhcxhfdm/2023/#{province_n}/#{prefecture_n}/#{args[:code]}.html")
    csv_file = 'db/townships.csv'
    dataset = {}

    if response.success?
      doc = Nokogiri::HTML(response.body)
      doc.css('tr.towntr').each do |row|
        code, name = row.css('td a').map(&:text)

        if code and name
          dataset[code] = name.strip
        end
      end

      output_string = generate_csv(dataset)
      output_file(csv_file, output_string)
    else
      puts response.body
    end
  end

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

  def csv_data(csv_file)
    if File.exist?(csv_file)
      CSV.parse(File.read(csv_file)).to_h
    else
      {}
    end
  end

  def generate_csv(hash)
    CSV.generate do |csv|
      hash.each do |code, name|
        csv << [code, name]
      end
    end
  end

  def output_file(filename, string)
    File.open(filename, 'w') do |f|
      f.write(string)
    end
  end
end
