#coding:utf-8
require 'unirest'

class SmsController < ApplicationController
  def send_sms
    phone_no = "" #phone number from Users table
    text = "hi there!".split(" ").join("+")
    url = "https://nexmo-nexmo-messaging-v1.p.mashape.com/send-sms?from=TRACKR&to=#{phone_no}&text=#{text}"

    logger.debug url

    response = Unirest.post(
      url,
      headers:{
        "X-Mashape-Key"   => "d7ddUEVAHbmshxUihi7xsDm24jLLp1dpGUNjsnIFOXk7NxijKA",
        "Content-Type"    => "application/x-www-form-urlencoded"
      }
    )

    logger.debug response.inspect

    render json: {status: response.code, message: response.body["message"]}
  end
end
