#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'ofx-parser'
require 'csv'
require 'active_support/inflector'

ofx_file = ARGV.shift
unless ofx_file and File.exists?(ofx_file)
  puts "Usage: #{File.basename(__FILE__)} /path/to/statement.ofx"
  exit 1
end

ofx = OfxParser::OfxParser.parse(open(ofx_file))

CSV.open("output.csv", "wb") do |csv|
  csv << ['date', 'memo', 'type', 'amount']
  ofx.bank_account.statement.transactions.each do |transaction|
    date  = transaction.date.strftime('%Y-%m-%d')
    memo  = ActiveSupport::Inflector.titleize(transaction.memo).gsub("\n",'').gsub!(/\s+/,' ')
    type  = ActiveSupport::Inflector.titleize(transaction.type)
    
    csv << [date, memo, type, transaction.amount]
  end
end
