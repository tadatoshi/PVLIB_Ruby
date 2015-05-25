require 'active_model'
require 'csv'

# Borrowed the idea from "http://kyle.conarro.com/importing-from-csv-in-rails".
class ActiveCsv
  include ActiveModel::Model

  attr_accessor :csv_filepath

  # def initialize(csv_filepath)
  #   @csv_filepath = csv_filepath
  # end

  def self.create(csv_filepath)
    # new_instance = self.new(csv_filepath)
    new_instance = self.new
    new_instance.csv_filepath = csv_filepath
    new_instance.load_data
    new_instance
  end

  def persisted?
    false
  end

  def valid?
    # TODO: implement this
  end

  def load_data
    csv = CSV.new(File.new(@csv_filepath), headers: true, header_converters: :symbol)

    data = csv.shift

    data.headers.each do |header|
      self.send("#{header}=".to_sym, data[header]) unless "#{header}=" == "="
    end

  end  

end