Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/api/hls',		to: 'api#hls'
  get  '/api/victims', 			  to: 'api#victims'
  get  '/api/searchers',		  to: 'api#searchers'
  post '/api/match_victim',		to: 'api#match_victim'

  get  '/api/generate_id',		to: 'api#generate_id'
  
  post '/api/input/victim',		to: 'api#input_victim'
  post '/api/input/searcher',	to: 'api#input_searcher'

  get '/api/consent/:searcher_id/:victim_id', to: 'api#consent'
  get '/api/claimed/:searcher_id/:victim_id', to: 'api#claimed'
  post '/api/victim/:victim_id/addons',   to: 'api#addons'

  # get  '/sms/send', 	to: 'sms#send_sms'
end