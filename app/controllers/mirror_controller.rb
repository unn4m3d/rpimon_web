require 'net/http'

class MirrorController < ApplicationController
  def index
  	begin
  		@machine = Machine.find(params[:id])
  		redir_params = {:show => params[:show],:catch => params[:catch]}

  		uri = URI(@machine.api_address)
  		uri.query = URI.encode_www_form(redir_params)

  		res = Net::HTTP.get_response(uri)

  		render json: res.body, status: res.code
  	rescue Errno::ECONNREFUSED
  		render json: JSON.generate({error: true, refused:true, summary: "Connection refused"})
  	rescue => e
  		render json: JSON.generate({error: true, summary:e.to_s})
  	end
  end
end
