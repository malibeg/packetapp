class DevicesController < ApplicationController
    before_action :set_device, only: [:show, :edit, :update, :destroy]
    skip_before_action :verify_authenticity_token, raise: false

  @@project_id = "ca73364c-6023-4935-9137-2132e73c20b4"
  @@packet_api = PacketApi.new(@@project_id)

  def index
    @devices = @@packet_api.list_devices #Packet.list_devices(@@project_id)
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = {} #Packet::Device.new
    @oses = @@packet_api.list_oses.map { |obj| obj['slug'] }
    @facilities = @@packet_api.list_facilities.map { |obj| obj['code'] }
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    # puts params.inspect
       
    device_params = {
      :hostname         => params[:hostname], #"t1-temp123",
      :plan             => params[:plan],
      :facility       => params[:facility],#'ewr1',
      :operating_system => params[:operating_system], #'Container Linux - Stable',
      :billing_cycle    => "hourly"
    }

    # puts "============================="
    # puts device_params.to_json
    # puts "============================="
    # @project = Packet.list_projects.first
    # params[:project_id] = @project.id
    # @device = Packet::Device.new(params)
    
    device =  @@packet_api.create_device(device_params)

    respond_to do |format|
      if !device[:error]
        format.html { redirect_to devices_url, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: _device }
      else
        format.html { redirect_to devices_url, notice:  'Error creating device. Error: ' + device[:error].message   }
        format.json { render json: {error: device.error}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @@packet_api.delete_device @device['id'] #Packet.delete_device(@device)
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = @@packet_api.get_device(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit!
    end
end
