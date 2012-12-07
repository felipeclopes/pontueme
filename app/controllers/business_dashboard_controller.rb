# encode: UTF-8

class BusinessDashboardController < ApplicationController
  before_filter :authenticate_business!
  
  def index
    @checkins = Checkin.find_all_by_business_id(current_business)
    @coupons = Coupon.includes(:benefit).find(:all, :conditions => ['benefits.business_id = ?', current_business])
    
    @all_users = current_business.users.to_a
    @connected_users = current_business.users.with_social_authentication.to_a
    
    self.social_chart
    self.gender_age_chart
  end
  
  protected
    
    def social_chart      
        @social = LazyHighCharts::HighChart.new('graph') do |f|
          #.....
        
          # chart options
          f.chart({
            renderTo: "container",
            plotBackgroundColor: false,
            plotBorderWidth: false,
            plotShadow: false
          })
                
          f.title(false)

          f.tooltip({
            pointFormat: "{series.name}: <b>{point.percentage}%</b>",
            percentageDecimals: 1
          })
        
          f.options[:plotOptions] = {
              pie: {
                  allowPointSelect: true,
                  cursor: 'pointer',
                  dataLabels: {
                      enabled: false
                  },
                  showInLegend: true
              }
          }
        
          f.series({
              type: "pie",
              name: "Total",
              data: [["Conectados", @connected_users.count],
                     ["Nao Conectados", @all_users.count - @connected_users.count]]
          })
        
          #...... 
        end
      
    end
    
    def gender_age_chart
      
      categories = ['0-4', '5-9', '10-14', '15-19',
                  '20-24', '25-29', '30-49', '49-100']
      
      @gender_age = LazyHighCharts::HighChart.new('graph') do |f|
        #.....
      
        # chart options
        f.chart({
          renderTo: "container",
          type: "bar"
        })
              
        f.title(false)
        
        f.xAxis({
            categories: categories
        })

        f.yAxis({
            min: 0,
            title: {
                text: 'Total de clientes'
            }
        })
      
        f.options[:plotOptions] = {
            series: {
                stacking: 'normal'
            }
        }
        
        mens = @connected_users.select{|m| m.gender == 'male'}        
        womens = @connected_users.select{|m| m.gender == 'female'}
        
        mens_age = []
        womens_age = []
        
        [5,10,15,20,25,30,50,1000].each do |age|
          mens_age << mens.select{|m| ((Time.now - m.birthday.to_time) / 1.year).floor < age}.count - (mens_age.sum || 0)
          womens_age << womens.select{|w| ((Time.now - w.birthday.to_time) / 1.year).floor < age}.count - (womens_age.sum || 0)
        end
        
        f.series({
            name: "Homens",
            data: mens_age
        })
      
        f.series({
            name: "Mulheres",
            data: womens_age
        })
      
        #...... 
      end
          
    end
    
end
