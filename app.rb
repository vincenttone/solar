#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'sinatra/base'
require 'haml'
class Solar < Sinatra::Base
  enable :sessions

  set :base_folder, File.dirname(__FILE__)
  set :views, File.dirname(__FILE__)+'/template'
  set :public_folder, File.dirname(__FILE__)+'/public'
  set :config_folder, File.dirname(__FILE__)+'/config'
  
  not_found do
    'Oops... The page not found!'
  end

  before '/' do
    redirect to('/resume') if session[:auth_code]
  end

  before '/resume*' do
    if session[:auth_code]
      require 'yaml'
      site_file = settings.config_folder + '/site.yml'
      filename = File.open site_file, 'r' do |f|
        file_content = f.read
        data = YAML.load file_content
        {:md=>data[:md_filename], :pdf=>data[:pdf_filename]}
      end
      @md_filename = filename[:md].to_sym
      @pdf_filename = filename[:pdf] + '.pdf'
    else
      #redirect to('/not_found'), 404
      redirect to('/')
    end
  end

  get '/' do
    haml :index, :layout=>:base
  end

  post '/auth' do
    code = params[:code]
    if check_code? code
      session[:auth_code] = code
      redirect to '/resume'
    else
      session[:msg] = '提取码错误！(Incorrect code!)'
      redirect to('/')
    end
  end

  get '/resume' do
    haml :resume, :layout=>:base
  end
  
  get '/resume/pdf' do
    content_type 'application/pdf;charset=utf-8'
    attachment @pdf_filename
    pdf = File.read settings.base_folder+"/assets/#{@pdf_filename}"
  end

  get '/logout' do
    session.delete :auth_code
    redirect to('/')
  end

  def check_code?(code)
    require 'yaml'
    auth_file = settings.config_folder + '/auth.yml'
    auth = File.open auth_file, 'r' do |f|
      file_content = f.read
      data = YAML.load file_content
      codes = data[:code]
      codes.include? code
    end
  end

end
