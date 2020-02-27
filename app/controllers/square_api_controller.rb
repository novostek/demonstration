class SquareApiController < ApplicationController

  def callback
    render json: {teste: "testendo"}
  end

end