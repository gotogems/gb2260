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

|      |                               File List |                              Download |
| ---- | --------------------------------------: | ------------------------------------: |
| 省级 |     [provinces.csv](./db/provinces.csv) |   [4.0K](https://dub.sh/cn-provinces) |
| 地级 | [prefectures.csv](./db/prefectures.csv) | [8.0K](https://dub.sh/cn-prefectures) |
| 县级 |       [counties.csv](./db/counties.csv) |     [56K](https://dub.sh/cn-counties) |
| 乡级 |     [townships.csv](./db/townships.csv) |   [908K](https://dub.sh/cn-townships) |

## References

- [全国统计用区划代码和城乡划分代码](https://www.stats.gov.cn/sj/tjbz/tjyqhdmhcxhfdm/2023/index.html)
- [统计用区划代码和城乡划分代码编制规则](https://www.stats.gov.cn/sj/tjbz/gjtjbz/202302/t20230213_1902741.html)

## License

This gem is released under the [1-clause BSD License](https://opensource.org/license/bsd-1-clause)
