class PacketApi
    def initialize(proj_id)
        @project_id = proj_id
        @headers = {
            :'X-Auth-Token' => ENV['PACKET_TOKEN'],
            :content_type => :json,
            :accept => :json
        }
    end

    def get_device device_id
        begin            
            url = "https://api.packet.net/devices/" + device_id
            resp = RestClient.get(url, @headers)
            device =  JSON.parse(resp.body)
        rescue => error
            puts error
            device = {:error => error}
        end 
    end

    def delete_device device_id
        begin            
            url = "https://api.packet.net/devices/" + device_id
            resp = RestClient.delete(url, @headers)
        rescue => error
            puts error
            resp = {:error => error}
        end 
    end

    def list_devices
        begin            
            url = "https://api.packet.net/projects/" + @project_id + "/devices"
            resp = RestClient.get(url, @headers)
            devices =  JSON.parse(resp.body)['devices']
        rescue => error
            puts error
            devices = []
        end 
    end

    def create_device(device_params)
        begin
            url = "https://api.packet.net/projects/" + @project_id + "/devices"
            resp = RestClient.post(url, 
            device_params.to_json,
            @headers)
            device =  JSON.parse(resp.body)
        rescue => error
            puts error
            device = {:error => error}
        end 
    end

    def list_facilities 
        begin            
            url = "https://api.packet.net/projects/" + @project_id + "/facilities"
            resp = RestClient.get(url, @headers)
            facilities = JSON.parse(resp.body)["facilities"]
        rescue => error
            puts error
            facilities = {:error => error}
        end 
    end

    def list_oses
        begin            
            url = "https://api.packet.net/operating-systems"
            resp = RestClient.get(url, @headers)
            oses =  JSON.parse(resp.body)["operating_systems"]
        rescue => error
            puts error
            oses = {:error => error}
        end
    end


end