# gb2260

A simple gem for looking-up administrative divisions

## Installation

```shell
gem install cn-gb2260
```

## Usage

```ruby
require 'gb2260'
division = Division.new(445100)
```

```
> division
Division {
code: 445100,
name: '潮州市',
isProvince: false,
isPrefecture: true,
isCounty: false,
type: 'prefecture'
}
```

## References

- [关于更新全国统计用区划代码和城乡划分代码的公告](https://www.stats.gov.cn/sj/tjbz/tjyqhdmhcxhfdm/2023/index.html)
- [统计用区划代码和城乡划分代码编制规则](https://www.stats.gov.cn/sj/tjbz/gjtjbz/202302/t20230213_1902741.html)

## License

**gb2260** is released under the [1-clause BSD License](https://opensource.org/license/bsd-1-clause)
