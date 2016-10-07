class HomeController < ApplicationController
  MenuElem = Struct.new(:active,:href,:title)

  def index
  	@menu = [
  		MenuElem.new(true,"/","Home"),
  		MenuElem.new(false,"https://telegram.me/unn4m3d","Telegram")
  	]

  	@machines = Machine.all
  end
end
