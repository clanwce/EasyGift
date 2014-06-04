class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = Authentication.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end

  # POST /authentications
  # POST /authentications.json
  def create
    @authentication = Authentication.new(params[:authentication])

    respond_to do |format|
      if @authentication.save
        format.html { redirect_to @authentication, notice: 'Authentication was successfully created.' }
        format.json { render json: @authentication, status: :created, location: @authentication }
      else
        format.html { render action: "new" }
        format.json { render json: @authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to authentications_url }
      format.json { head :no_content }
    end
  end
end
