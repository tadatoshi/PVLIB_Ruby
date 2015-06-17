require 'active_model'
require 'csv'

# This is a model in model-view-controller design pattern. 
# It is analogous to ActiveRecord. Hence, it's a placeholder for data from CSV file. 
# Borrowed the idea from "http://kyle.conarro.com/importing-from-csv-in-rails".
class ActiveCsv
  include ActiveModel::Model

  def self.create(csv_filepath)
    new_instance = self.new
    new_instance.load_data(csv_filepath)
    new_instance
  end

  def persisted?
    false
  end

  def valid?
    # TODO: implement this
  end

  def load_data(csv_filepath)
    csv = CSV.new(File.new(csv_filepath), headers: true, header_converters: :symbol)

    data = csv.shift

    previous_header = nil;
    index = 0;

    data.headers.each do |header|

      if "#{header}=" == "="

        if !previous_header.blank? && !data[index].blank?

          assigned_data_for_previous_header = self.send(previous_header.to_sym)
          
          if assigned_data_for_previous_header.instance_of? Array
            assigned_data_for_previous_header << data[index]
            self.send("#{previous_header}=".to_sym, assigned_data_for_previous_header)
          else
            self.send("#{previous_header}=".to_sym, [assigned_data_for_previous_header,data[index]])
          end

        end

      else
        self.send("#{header}=".to_sym, data[header])
      end

      previous_header = header unless header.blank?
      index = index + 1;

    end

  end  

end