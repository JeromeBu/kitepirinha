# gem 'capybara'
# gem 'poltergeist'

require "capybara"
require "capybara/dsl"
require 'capybara/poltergeist'
require 'pry-byebug'
require 'csv'


class Scraper
  include Capybara::DSL


  def run
    Capybara.default_max_wait_time = 15
    Capybara.configure do |c|
      c.javascript_driver = :poltergeist
      c.default_driver = :poltergeist
    end
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {
        js_errors: false,
        window_size: [1280, 3200],
        debug: false,
        phantomjs_options: ['--debug=no', '--load-images=yes', '--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1'],
        timeout: 45,
        headers: { 'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X)" }
      })
    end

    Capybara.app_host = "http://maree.shom.fr"
#    page.driver.browser.clear_cookies
    visit('/vignette')
    #all('span', text: "Choisissez votre projet...").last.trigger('click')
    wait_for_ajax
    #p page.body

    ports = []
    ('a'..'z').to_a.each do |letter|
      find('#ember433').trigger('click')
      find('#ember433').native.send_keys(:Backspace)
      find('#ember433').native.send_keys(letter)
      sleep 0.5
      puts letter
      # visual_log
      all(".tt-suggestion").map(&:text).each do |port|
        ports << port
      end
    end
    ports.sort!.uniq!

    test_string = ports.first
    my_regexp = /(?<debut>([a-zA-Z\(\)\-. ])*)\((?<query>[A-Z-_]*)\)(?<fin>([a-zA-Z\(\)\-. ])*)/


    require 'csv'
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    filepath    = 'db/ports.csv'
    CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << ['Name', 'Country', 'Query_Name']
      ports.each do |port|
        matches = port.match(my_regexp)
        csv << [matches[:debut].strip, matches[:fin].strip, matches[:query]]
      end
    end

    #fill_in "duree", with: credit.n_of_months, visible: false
    #find_by_id("submit", visible: false).trigger('click')

    # binding.pry
    # ""
  end

  def visual_log(name: "screen-#{DateTime.now.to_i}", open: false)
   if open
     save_and_open_screenshot
   else
     path = Rails.root.join("tmp", "capybara", "#{name}.png")
     page.save_screenshot(path)
   end
  end


  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until page.evaluate_script('jQuery.active').zero?
    end
  end

  def geocode_them_all
    require "csv"

    in_ram_csv = []

    CSV.foreach("db/ports.csv") do |row|
      in_ram_csv << row
    end


    count = 0
    in_ram_csv.map do |row|
      if count == 0
        row[3] = "Latitude"
        row[4] = "Longitude"
      else
        if row[3] == "" || !row[3]
          coords = ArtisanalGeocoder.geo(row[0] + " " + row[1])
          puts coords
          row[3] = coords[:lat]
          row[4] = coords[:lng]
        end
      end
      count += 1
      row
    end

    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open('db/ports.csv', 'wb', csv_options) do |csv|
      in_ram_csv.each do |line|
        csv << line
      end
    end

    p in_ram_csv.first
    p in_ram_csv.second
      # if count < 10
      #   puts row
      #   if count == 0
      #   else
      #     if row[3] == "" || !row[3]
      #     end
      #   end
      #   count += 1
      # end
      # # row is an array. For first iteration:
      # # row[0] is "Paris"
      # # row[1] is 2211000, etc.

  end

end

a = Scraper.new
a.geocode_them_all
