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

get '/highchartscss' do
  highcharts_css
  erb :highcharts_css, :layout => :highcharts_layout
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

def highcharts_css
    # set the library, to plot charts
  Daru::View.plotting_library = :highcharts

  # options for the charts
  opts = {
    chart: {defaultSeriesType: 'line'},
    css: ['.highcharts-background {fill: #efefef;stroke: #a4edba;stroke-width: 2px;}'],
    title: {
      text: 'Solar Employment Growth by Sector, 2010-2016'
    },

    subtitle: {
      text: 'Source: thesolarfoundation.com'
    },

    yAxis: {
      title: {
        text: 'Number of Employees'
      }
    },
    legend: {
      layout: 'vertical',
      align: 'right',
      verticalAlign: 'middle'
    }
  }

  # data for the charts
  data = Daru::Vector.new([29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4])

  # initialize
  @line_graph = Daru::View::Plot.new(data, opts)

  opts2 = {
    chart: {
      type: 'column'
    },

    css: ['.highcharts-color-0 {fill: #7cb5ec;stroke: #7cb5ec;}',
          '.highcharts-axis.highcharts-color-0 .highcharts-axis-line {stroke: #7cb5ec;}',
          '.highcharts-axis.highcharts-color-0 text {fill: #7cb5ec;}',
          '.highcharts-color-1 {fill: #90ed7d;stroke: #90ed7d;}',
          '.highcharts-axis.highcharts-color-1 .highcharts-axis-line {stroke: #90ed7d;}',
          '.highcharts-axis.highcharts-color-1 text {fill: #90ed7d;}',
          '.highcharts-yaxis .highcharts-axis-line {stroke-width: 2px;}'
          ],

    title: {
        text: 'Styling axes'
    },

    yAxis: [{
        className: 'highcharts-color-0',
        title: {
            text: 'Primary axis'
        }
    }, {
        className: 'highcharts-color-1',
        opposite: true,
        title: {
            text: 'Secondary axis'
        }
    }],

    plotOptions: {
        column: {
            borderRadius: 5
        }
    }
  }

  series_dt2 = [{
    data: [1, 3, 2, 4]
  }, {
      data: [324, 124, 547, 221],
      yAxis: 1
  }]

  # initialize
  @column_graph = Daru::View::Plot.new(series_dt2, opts2)
end

