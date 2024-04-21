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

  task :prefectures do
    response = conn.get('/sj/tjbz/tjyqhdmhcxhfdm/2023/44.html')
    dataset = {}

    if response.success?
      doc = Nokogiri::HTML(response.body)
      doc.css('tr.citytr').each do |row|
        code, name = row.css('td a').map(&:text)
        dataset[code[0, 6]] = name.strip
      end

      output = CSV.generate do |csv|
        dataset.each do |code, name|
          csv << [code, name]
        end
      end

      puts output
    else
      puts response.body
    end
  end

  task :counties do
    response = conn.get('/sj/tjbz/tjyqhdmhcxhfdm/2023/44/4451.html')
    dataset = {}

    if response.success?
      doc = Nokogiri::HTML(response.body)
      doc.css('tr.countytr').each do |row|
        code, name = row.css('td a').map(&:text)

        if code and name
          dataset[code[0, 6]] = name.strip
        end
      end

      output = CSV.generate do |csv|
        dataset.each do |code, name|
          csv << [code, name]
        end
      end

      puts output
    else
      puts response.body
    end
  end

  task :divisions do
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

# response = Faraday.get('https://www.stats.gov.cn/sj/tjbz/tjyqhdmhcxhfdm/2023/44/51/445103.html')

# if response.success?
#   doc = Nokogiri::HTML(response.body)
#   doc.css('tr.towntr td a').each do |link|\
#     puts link.attr(:href)
#     puts link.text
#   end
# end
