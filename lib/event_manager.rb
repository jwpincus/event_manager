require 'pry-state'
require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.rjust(5, "0")[0..4]
end

def legislators_by_zip(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  legislator_names = legislators.map do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end.join(", ")
  legislator_names
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
  zipcode = row[:zipcode].to_s
  zipcode = clean_zipcode(zipcode)
  legislator_names = legislators_by_zip(zipcode)
  puts "#{row[:first_name]} #{zipcode} #{legislator_names}"
end