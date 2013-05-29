#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'pdfkit'
require 'rdiscount'

def get_html(html)
doc = <<HTML
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
HTML
doc << html
doc << <<HTML
  </body>
</html>
HTML
end

dir = File.realpath(File.dirname(__FILE__) + '/../')
require 'yaml'
site_file = dir + '/config/site.yml'
site = File.open site_file, 'r' do |f|
  file_content = f.read
  data = YAML.load file_content
  {:md=>data[:md_filename], :pdf=>data[:pdf_filename]}
end
file =  File.read dir+"/template/#{site[:md]}.md"
html = RDiscount.new( file , :smart, :filter_html).to_html
html = get_html html
kit = PDFKit.new html
kit.to_file(dir+"/assets/#{site[:pdf]}.pdf")
