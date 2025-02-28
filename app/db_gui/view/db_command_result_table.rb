require 'db_gui/model/db_config'

class DbGui
  module View
    class DbCommandResultTable
      include Glimmer::LibUI::CustomControl
      
      option :db_config
      
      body {
        vertical_box {
          content(db_config, :db_command_result) {
            db_command_result_lines = db_config.db_command_result.lines
            db_command_result_lines.pop if db_command_result_lines.last == "\n"
            if db_command_result_lines.any?
              headers = db_command_result_lines.first.split('|').map(&:strip)
              count_footer = db_command_result_lines.last
              count_footer_match = count_footer.match(/^\((\d+) row/)
              if count_footer_match
                rows = db_command_result_lines[2..-2].map {|row| row.split('|').map(&:strip) }
                table {
                  headers.each do |header|
                    text_column(header)
                  end
                  
                  cell_rows rows
                }
              else
                label('No data')
              end
            else
              label('No data')
            end
          }
        }
      }
    end
  end
end
            
