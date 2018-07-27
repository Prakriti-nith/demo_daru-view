require 'sinatra'
require 'daru/view'


get '/' do
  erb :index , :layout => :layout
end

get '/nyaplot' do
  nyaplot_example()
  erb :nyaplot, :layout => :nyaplot_layout
end

get '/highcharts' do
  highchart_example
  erb :highcharts, :layout => :highcharts_layout
end

get '/googlecharts' do
  googlecharts_example
  erb :googlecharts, :layout => :googlecharts_layout
end

get '/highchartstockmap' do
  highchart_stock_map
  erb :highchart_stock_map, :layout => :highcharts_layout
end

def highchart_example
    # bar chart
    opts = {
        chart: {
          type: 'bar',
      },
      title: {
          text: 'Historic World Population by Region'
      },
      subtitle: {
          text: 'Source: <a href="https://en.wikipedia.org/wiki/World_population">Wikipedia.org</a>'
      },
      xAxis: {
          categories: ['Africa', 'America', 'Asia', 'Europe', 'Oceania'],
          title: {
              text: nil
          }
      },
      yAxis: {
          min: 0,
          title: {
              text: 'Population (millions)',
              align: 'high'
          },
          labels: {
              overflow: 'justify'
          }
      },
      tooltip: {
          valueSuffix: ' millions'
      },
      plotOptions: {
          bar: {
              dataLabels: {
                  enabled: true
              }
          }
      },
      legend: {
          layout: 'vertical',
          align: 'right',
          verticalAlign: 'top',
          x: -40,
          y: 80,
          floating: true,
          borderWidth: 1,
          backgroundColor: '#FFFFFF',
          shadow: true
      },
      credits: {
          enabled: false
      },
      adapter: :highcharts
    }

    series_dt = [
      {
          name: 'Year 1800',
          data: [107, 31, 635, 203, 2]
      }, {
          name: 'Year 1900',
          data: [133, 156, 947, 408, 6]
      }, {
          name: 'Year 2012',
          data: [1052, 954, 4250, 740, 38]
      }
    ]
    @bar_basic = Daru::View::Plot.new([], opts)
    @bar_basic.add_series(series_dt[0])
    @bar_basic.add_series(series_dt[1])
    @bar_basic.add_series(series_dt[2])

    # @line_graph = Daru::View::Plot.new(data= make_random_series(3), adapter: :highcharts, name: 'spline1', type: 'spline', title: 'Irregular spline')
end


def nyaplot_example
    dv = Daru::Vector.new [:a, :a, :a, :b, :b, :c], type: :category
    # default adapter is nyaplot only
    @bar_graph = Daru::View::Plot.new(dv, type: :bar, adapter: :nyaplot)

    df = Daru::DataFrame.new({b: [11,12,13,14,15], a: [1,2,3,4,5],
      c: [11,22,33,44,55]},
      order: [:a, :b, :c],
      index: [:one, :two, :three, :four, :five])
    @scatter_graph = Daru::View::Plot.new df, type: :scatter, x: :a, y: :b, adapter: :nyaplot

    df = Daru::DataFrame.new({
      a: [1, 3, 5, 7, 5, 0],
      b: [1, 5, 2, 5, 1, 0],
      c: [1, 6, 7, 2, 6, 0]
      }, index: 'a'..'f')
    @df_line = Daru::View::Plot.new df, type: :line, x: :a, y: :b, adapter: :nyaplot
end

def googlecharts_example
  country_population = [
          ['Germany', 200],
          ['United States', 300],
          ['Brazil', 400],
          ['Canada', 500],
          ['France', 600],
          ['RU', 700]
    ]
  df_cp = Daru::DataFrame.rows(country_population)
  df_cp.vectors = Daru::Index.new(['Country', 'Population'])
  @table = Daru::View::Table.new(df_cp, pageSize: 5, adapter: :googlecharts, height: 400, width: 300)
  @piechart = Daru::View::Plot.new(
    @table.table, type: :pie, is3D: true, adapter: :googlecharts, height: 500, width: 800)
  @geochart = Daru::View::Plot.new(
    @table.table, type: :geo, adapter: :googlecharts, height: 500, width: 800)
end

def make_random_series(step)
  data = []
  for i in 0..10
    data << [(rand * 100).to_i]
  end
  data
end

def highchart_stock_map
    # set the library, to plot charts
  Daru::View.plotting_library = :highcharts

  # options for the charts
  chart = {
    type: 'line'
  },
  opts = {
    title: {
      text: 'AAPL Stock Price'
    },
    chart_class: 'stock',
    rangeSelector: {
      selected: 1
    } 
  }

  opts2 = {
    title: {
      text: 'AAPL Stock Price'
    }
  }

  # data for the charts
  series_dt = ([{
    name: 'AAPL',
    data: [
         [1147651200000,67.79],
         [1147737600000,64.98],
         [1147824000000,65.26],

         [1149120000000,62.17],
         [1149206400000,61.66],
         [1149465600000,60.00],
         [1149552000000,59.72],

         [1157932800000,72.50],
         [1158019200000,72.63],
         [1158105600000,74.20],
         [1158192000000,74.17],
         [1158278400000,74.10],
         [1158537600000,73.89],

         [1170288000000,84.74],
         [1170374400000,84.75],

         [1174953600000,95.46],
         [1175040000000,93.24],
         [1175126400000,93.75],
         [1175212800000,92.91],

         [1180051200000,113.62],
         [1180396800000,114.35],
         [1180483200000,118.77],
         [1180569600000,121.19],
         ]
    }])

  # initialize
  @stock = Daru::View::Plot.new(series_dt, opts)
  @hchart = Daru::View::Plot.new(series_dt, opts2)

  opts3 = {
    chart_class: 'map',
    chart: {
      map: 'countries/in/in-all'
    },

    title: {
        text: 'Highmaps basic demo'
    },

    subtitle: {
        text: 'Source map: <a href="http://code.highcharts.com/mapdata/countries/in/in-all.js">India</a>'
    },

    mapNavigation: {
        enabled: true,
        buttonOptions: {
            verticalAlign: 'bottom'
        }
    },

    colorAxis: {
        min: 0
    }
  }

  df = Daru::DataFrame.new(
    {
      countries: ['in-py', 'in-ld', 'in-wb', 'in-or', 'in-br', 'in-sk', 'in-ct', 'in-tn', 'in-mp', 'in-2984', 'in-ga', 'in-nl', 'in-mn', 'in-ar', 'in-mz', 'in-tr', 'in-3464', 'in-dl', 'in-hr', 'in-ch', 'in-hp', 'in-jk', 'in-kl', 'in-ka', 'in-dn', 'in-mh', 'in-as', 'in-ap', 'in-ml', 'in-pb', 'in-rj', 'in-up', 'in-ut', 'in-jh'],
      data: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
    }
  )
  @map = Daru::View::Plot.new(df, opts3)


  opts4 = {
    chart_class: 'map',
    chart: {
      map: 'custom/europe',
      spacingBottom: 20
    },

    title: {
      text: 'Europe time zones'
    },

    legend: {
      enabled: true
    },

    plotOptions: {
      map: {
        allAreas: false,
        joinBy: ['iso-a2', 'code'],
        dataLabels: {
            enabled: true,
            color: '#FFFFFF',
            style: {
                fontWeight: 'bold'
            },
            # Only show dataLabels for areas with high label rank
            format: nil,
            formatter: "function () {
                if (this.point.properties && this.point.properties.labelrank.toString() < 5) {
                    return this.point.properties['iso-a2'];
                }
            }".js_code
        },
        tooltip: {
            headerFormat: '',
            pointFormat: '{point.name}: <b>{series.name}</b>'
        }
      }
    }
  }


  series_dt4 = [
    {
      name: 'UTC',
      data: "['IE', 'IS', 'GB', 'PT'].map(function (code) {
          return { code: code };
      })".js_code
  }, {
      name: 'UTC + 1',
      data: "['NO', 'SE', 'DK', 'DE', 'NL', 'BE', 'LU', 'ES', 'FR', 'PL', 'CZ', 'AT', 'CH', 'LI', 'SK', 'HU',
          'SI', 'IT', 'SM', 'HR', 'BA', 'YF', 'ME', 'AL', 'MK'].map(function (code) {
              return { code: code };
          })".js_code
  }, {
      name: 'UTC + 2',
      data: "['FI', 'EE', 'LV', 'LT', 'BY', 'UA', 'MD', 'RO', 'BG', 'GR', 'TR', 'CY'].map(function (code) {
          return { code: code };
      })".js_code
  }, {
      name: 'UTC + 3',
      data: "[{
          code: 'RU'
      }]".js_code
    }
  ]

  @map_europe = Daru::View::Plot.new(series_dt4, opts4)


  opts5 = {
      chart: {
        type: 'pie',
        options3d: {
            enabled: true,
            alpha: 45,
            beta: 0
        }
      },
      title: {
          text: 'Browser market shares at a specific website, 2014'
      },
      tooltip: {
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      },
      plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            depth: 35,
            dataLabels: {
                enabled: true,
                format: '{point.name}'
            }
        }
      }
    }

  # data for the charts
  series_dt5 = ([{
    type: 'pie',
    name: 'Browser share',
    data: [
        ['Firefox', 45.0],
        ['IE', 26.8],
        {
            name: 'Chrome',
            y: 12.8,
            sliced: true,
            selected: true
        },
        ['Safari', 8.5],
        ['Opera', 6.2],
        ['Others', 0.7]
    ]
  }])

  # initialize
  @chart3d = Daru::View::Plot.new(series_dt5, opts5)


  opts6 = {
      chart_class: 'stock',
      chart: {
          type: 'arearange'
      },
      rangeSelector: {
          selected: 2
      },
      modules: ['highcharts-more'],

      title: {
          text: 'Temperature variation by day'
      },

      tooltip: {
          valueSuffix: '°C'
      }
  }

  series_dt6 = [
    {
      name: 'Temperatures',
      data: [
              [1483232400000, 1.4, 4.7],
              [1483318800000, -1.3, 1.9],
              [1483405200000, -0.7, 4.3],
              [1483491600000, -5.5, 3.2],
              [1483578000000, -9.9, -6.6],
              [1483664400000, -9.6, 0.1],
              [1483750800000, -0.9, 4.0],
              [1497571200000, 12.3, 14.9],
              [1497657600000, 10.5, 15.1],
              [1497744000000, 11.4, 18.0],
              [1497830400000, 9.9, 14.8],
              [1497916800000, 8.1, 12.4],
              [1498003200000, 8.6, 15.5],
              [1498089600000, 9.4, 13.0],
              [1498176000000, 11.2, 13.0],
              [1498262400000, 9.0, 15.3],
              [1498348800000, 7.7, 13.6],
              [1498435200000, 10.3, 13.6],
              [1498521600000, 6.3, 18.0],
              [1505347200000, 5.1, 15.3],
              [1505433600000, 6.7, 16.8],
              [1505520000000, 4.0, 16.1],
              [1505606400000, 3.5, 15.8],
              [1505692800000, 8.1, 12.7],
              [1505779200000, 10.4, 13.4],
              [1514163600000, 1.0, 3.1],
              [1514250000000, 1.3, 1.6],
              [1514336400000, 0.8, 1.3],
              [1514422800000, -3.3, -1.4],
              [1514509200000, -1.5, -0.2],
              [1514595600000, -2.7, -1.0],
              [1514682000000, -2.8, 0.3]
            ]
    }
  ]

  @area_range = Daru::View::Plot.new(series_dt6, opts6)

  opts8 = {
    chart: {
        type: 'tilemap',
        marginTop: 15,
        height: '65%'
    },

    modules: ['modules/tilemap'],

    title: {
        text: 'Idea map'
    },

    subtitle: {
        text: 'Hover over tiles for details'
    },

    colors: [
        '#fed',
        '#ffddc0',
        '#ecb',
        '#dba',
        '#c99',
        '#b88',
        '#aa7577',
        '#9f6a66'
    ],

    xAxis: {
        visible: false
    },

    yAxis: {
        visible: false
    },

    legend: {
        enabled: false
    },

    tooltip: {
        headerFormat: '',
        backgroundColor: 'rgba(247,247,247,0.95)',
        pointFormat: '<span style="color: {point.color}">●</span>' +
            '<span style="font-size: 13px; font-weight: bold"> {point.name}' +
            '</span><br>{point.desc}',
        style: {
            width: 170
        },
        padding: 10,
        hideDelay: 1000000
    },

    plotOptions: {
        series: {
            keys: ['x', 'y', 'name', 'desc'],
            tileShape: 'diamond',
            dataLabels: {
                enabled: true,
                format: '{point.name}',
                color: '#000000',
                style: {
                    textOutline: false
                }
            }
        }
    }
  }

  series_dt8 = [{
      name: 'Main idea',
      pointPadding: 10,
      data: [
          [5, 3, 'Main idea',
              'The main idea tile outlines the overall theme of the idea map.']
      ],
      color: '#7eb'
  }, {
      name: 'Steps',
      colorByPoint: true,
      data: [
          [3, 3, 'Step 1',
              'First step towards the main idea. Describe the starting point of the situation.'],
          [4, 3, 'Step 2',
              'Describe where to move next in a short term time perspective.'],
          [5, 4, 'Step 3',
              'This can be a larger milestone, after the initial steps have been taken.'],
          [6, 3, 'Step 4',
              'Evaluate progress and readjust the course of the project.'],
          [7, 3, 'Step 5',
              'At this point, major progress should have been made, and we should be well on our way to implementing the main idea.'],
          [6, 2, 'Step 6',
              'Second evaluation and readjustment step. Implement final changes.'],
          [5, 2, 'Step 7',
              'Testing and final verification step.'],
          [4, 2, 'Step 8',
              'Iterate after final testing and finalize implementation of the idea.']
      ]
  }]

  @map_idea = Daru::View::Plot.new(series_dt8, opts8)
end
