namespace :divisions do
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

  task :prefectures do
    response = conn.get("/sj/tjbz/tjyqhdmhcxhfdm/2023/44.html")
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
    response = conn.get("/sj/tjbz/tjyqhdmhcxhfdm/2023/44/4451.html")

    if response.success?
      doc = Nokogiri::HTML(response.body)
      doc.css('tr.countytr td a').each do |link|
        puts link.attr(:href)
        puts link.text
      end
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
