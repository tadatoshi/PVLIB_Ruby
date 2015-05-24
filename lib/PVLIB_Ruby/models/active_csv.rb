require 'active_model'
require 'csv'

# Borrowed the idea from "http://kyle.conarro.com/importing-from-csv-in-rails".
class ActiveCsv
  include ActiveModel::Model

  def initialize(csv_filepath)
    @csv_filepath = csv_filepath
  end

  def persisted?
    false
  end

  def valid?

    binding.pry

    record_attributes = load_data
    # import_records = record_attributes.map {|attrs| MyModel.new(attrs)}
    # import_records.map(&:valid?).all?
  end

  def load_data
    # csv = CSV.new(File.new(@csv_filepath), headers: true, return_headers: true, header_converters: :symbol)
    csv = CSV.new(File.new(@csv_filepath), headers: true, header_converters: :symbol)

    data = csv.shift
    puts "data: #{data}"
    puts "data.headers: #{data.headers}"

    data.headers.each do |header|
      puts "data[header]: #{data[header]}"

      self.send("#{header}=".to_sym, data[header]) unless "#{header}=" == "="
    end

    # CSV.foreach(@csv_filepath, headers: true, header_converters: :symbol) do |row|
      
    #   puts "row: #{row}"
    #   puts "row.headers: #{row.headers}"

    #   break;

    # end
    # return some useful data for making records
  end  

end