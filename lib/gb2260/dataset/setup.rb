require 'gb2260/dataset/utils'
require 'gb2260/dataset'
require 'csv'

File.expand_path('../../../', __dir__).tap do |root|
  GB2260::Dataset.import("#{root}/db/provinces.csv")
  GB2260::Dataset.import("#{root}/db/prefectures.csv")
  GB2260::Dataset.import("#{root}/db/counties.csv")
end
