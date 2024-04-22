require_relative 'lib/gb2260/version'

Gem::Specification.new do |spec|
  spec.name     = 'gb2260'
  spec.version  = GB2260::VERSION
  spec.licenses = ['BSD-1-Clause']
  spec.homepage = 'https://github.com/gotogems/gb2260'
  spec.summary  = 'List administrative divisions'
  spec.author   = 'Z290b2dlbXM'
  spec.email    = 'goto@iamust.work'
  spec.files    = ['bin/gb2260'].concat(Dir['db/*.csv'])
                                .concat(Dir['lib/**/*.rb'])

  spec.executable = 'gb2260'
  spec.required_ruby_version = '>= 3.0'
end
