class HomeController < ApplicationController

  def index
  	@page_id = 0

  	@menu = MenuElement.all

  	@machines = Machine.all
  end
end
