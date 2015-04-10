require_relative '../view/window'

require 'gtk2'

class AboutScreen
  include window
  attr_reader :view

  def initialize (msg)
    @view = Gtk::AboutDialog.new
    @view.name = 'Ruby 4'
    @view.program_name = 'Ruby 4'
    @view.authors = ['Kirby Banman', 'Ryan Thornhill']
    #@view.version = '1.0'
    @view.website = 'https://github.com/kdbanman/ruby_four'
    #TODO change this if we support T's and O's for a single player
    @view.comments = <<EOF
Rules:
1.) Click on a column to place a token
2.) Win by connecting 4 of your type of token
EOF
    @view.run
    @view.destroy
  end


end