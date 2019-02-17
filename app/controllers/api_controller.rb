#coding:utf-8
require 'unirest'
require 'cgi'

class ApiController < ApplicationController
	DOMAIN = "http://ec2-54-250-245-163.ap-northeast-1.compute.amazonaws.com:3005"

	def generate_id
		v_count = Victim.select("id").where(done: 0).order("id desc").first
		s_count = Searcher.select("id").where(done: 0).order("id desc").first

		render json: ({victim_id: v_count[:id], searcher_id: s_count[:id]})
	end

	def input_victim
		begin
			info = {
				location: params[:address],
				phone: params[:phoneNumber],
				pic: params[:photoKey]
			}				
			res = Victim.new
			res.save_record(params)

			render json: {status: "200", message: "Success"}
		rescue => e
			render :json => { :errors => e.message }
		end
	end

	def input_searcher
		begin
			info = {
				location: params[:address],
				phone: params[:phoneNumber],
				pic: params[:photoKey]
			}	

			res = Searcher.new
			res.save_record(params)

			render json: {status: "200", message: "Success"}
		rescue => e
			render :json => { :errors => e.message }
		end
	end

	def victims
		results = Victim.where(done: 0)
		render json: results
	end

	def searchers
		results = Searcher.where(done: 0)
		render json: results
	end

	def match_victim
		all_data = params

		begin
			all_data["_json"].each do | data |
				searcher_id = data["searcher"]
				searcher = Searcher.find(searcher_id)
				if searcher_id.present?
					#send nexmo text message to searchers
					msg = "Woof! It's Trakr! I found leads who might be your missing person. Release of details would follow after the reporter's consent. Please stand by, I'm with you!"
					send_sms(searcher["phone"], msg)

					#send nexmo text message to related victims
					data["matches"].each do | v_data |
						v = Victim.find(v_data[:victim_id])
						consent = Consent.new
						consent_params = {
							:searcher_id	=> searcher_id,
							:victim_id		=> v_data["victim_id"],
							:consent 		=> 0
						}
						consent.save_record(consent_params)

						url = "#{DOMAIN}/api/consent/#{searcher_id}/#{v_data[:victim_id]}"
						msg = "Woof! Trakr here! We found a match to the missing person. Please consent by tapping here: \n#{url} "
						send_sms(v.phone, msg)
					end
				end
			end
			render json: {status: "200", message: "Success"}
		rescue => e
			render :json => { :errors => e.message }
		end		
	end

	def consent
		searcher_id = params[:searcher_id]
		victim_id = params[:victim_id]

		consent = Consent.where(:searcher_id => searcher_id, :victim_id => victim_id).first
		consent.save_record({consent: 1})

		victim_info = Victim.find(victim_id)
		gender = nil
		age = nil

		msg = "Woof! Trakr at your service! \nWe got a consent from the reporter. \nHere are the information of the possible match.\n"
		msg += "Location: #{victim_info[:location]}\n"
		msg += "Age: #{victim_info[:age]}\n" if victim_info[:age].present?
		msg += "Gender: #{victim_info[:gender]}\n" if victim_info[:gender].present?
		send_sms(searcher["phone"], msg)

	end

	def claimed
		model = Victim.new
		model.done_record
	end

	def send_sms(phone_no, text)
		text = CGI.escape(text)
		url = "https://nexmo-nexmo-messaging-v1.p.mashape.com/send-sms?from=Trackr&to=#{phone_no}&text=#{text}"

		response = Unirest.post(
		  url,
		  headers:{
		    "X-Mashape-Key"   => "d7ddUEVAHbmshxUihi7xsDm24jLLp1dpGUNjsnIFOXk7NxijKA",
		    "Content-Type"    => "application/x-www-form-urlencoded"
		  }
		
)  	end

  	def addons
  		begin
  			model = Victim.find(params[:victim_id])
  			model.save_record(params)
  		rescue => e
  			render :json => { :errors => e.message }
  		end
  	end
end