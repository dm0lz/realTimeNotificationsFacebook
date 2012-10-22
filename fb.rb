require 'bundler/setup'
require 'sinatra'
require 'omniauth-facebook'
require 'pry'
require 'koala'


class FacebookNotifications < Sinatra::Base

  enable :sessions



  use OmniAuth::Builder do
    provider  :facebook, 
              '268692613242267', 
              '49a2edd10567a5d8e430fb53c6e111d6',
              scope: 'email,read_stream,publish_stream,manage_pages'
  end


  before '/' do  
    redirect '/auth/facebook' unless session['access_token']
  end


  get '/auth/facebook/callback' do 
    session['access_token'] = env['omniauth.auth']['credentials'].token
    redirect '/'
  end


  get '/' do
    #@connection = start_graph graph.get_connections('me', 'accounts').first['access_token']
    @graph = graph
    
    binding.pry 
  end


  helpers do 
    def graph
      @graph ||= start_graph session['access_token']
    end

    def start_graph access_token
      Koala::Facebook::API.new access_token
    end

  end


end