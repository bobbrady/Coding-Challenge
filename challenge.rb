# This is a coding challenge I did in about an hour for an interview with startup company Localytics
#####################################################################################################
# See the two tab delimited files attached:

# products.tab = A list of product names tab delimited with categories
# sales.tab = A list of product names tab delimited with sales amount

# From this data we'd like you to answer two questions:
# What are the top 5 categories by sales
# What is the top product by sales in category 'Candy'

# This comes from when I worked at a company that made back office software for restaurants.  
# You can imagine the second file is a Point of Sale record for the day.
#####################################################################################################
# my attempt:

class Product
  attr_accessor :category, :sales_amount

  def initialize(name, sales_amount, category)
    @name = name
    @sales_amount = sales_amount
    @category = category
  end

  class << self
    def create_products(sales_file, category_file)
      @product_hash = {}
      
      File.readlines(sales_file).each do |line|
        if(line.split("\t")[0] && line.split("\t")[1]) #content on both sides of tab
          sales_file_product_name = line.split("\t")[0].strip
          product_sales_amount = line.split("\t")[1].strip.to_f
          if(!@product_hash[sales_file_product_name])
            @product_hash[sales_file_product_name] = Product.new(sales_file_product_name, product_sales_amount, nil)
          end
        end
      end

      File.readlines(category_file).each do |line|
        if(line.split("\t")[0] && line.split("\t")[1])
          category_file_product_name = line.split("\t")[0].strip
          product_category = line.split("\t")[1].strip
          if(@product_hash[category_file_product_name])
            @product_hash[category_file_product_name].category = product_category
          end
        end
      end

      @product_hash
    end

    def categorize_products(product_hash)
      ctgs = {} #categories
      product_hash.each do |product_name, product|
        category = product.category
        ctgs[category] ? (ctgs[category] += product.sales_amount) : (ctgs[category] = product.sales_amount)
      end
      ctgs.sort_by {|k, v| v}.reverse.take(5).each do |category, sales_amount|
        puts "#{category} - #{sales_amount}"
        puts ''
      end
    end

    def top_product_in_candy(product_hash)
      cps = {} #candy products
      product_hash.each do |product_name, product|
        if(product.category == 'Candy')
          cps[product_name] ? (cps[product_name] += product.sales_amount) : (cps[product_name] = product.sales_amount)
        end
      end
      puts cps.sort_by {|k, v| v}.reverse.take(1)
    end
  end

end

products = Product.create_products("sales.tab", "products.tab")
Product.categorize_products(products)
Product.top_product_in_candy(products)
