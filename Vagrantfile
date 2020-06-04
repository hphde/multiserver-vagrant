Vagrant.configure("2") do |config|
  # vagrant plugin install vagrant-env
  #config.env.enable
  
  BOX = ENV['BOX'] || 'centos/7'
  NETWORK_MASK = ENV['NETWORK_MASK'] || 24
  NETWORK_BASE = ENV['NETWORK_BASE'] || '192.168.56.0'
  MEM = ENV['MEM'] || 1024
  CPUS = ENV['CPUS'] || 2
  BOOTSTRAP = ENV['BOOTSTRAP'] || 'bootstrap.sh'
  TIMEZONE = ENV['TIMEZONE'] || 'Europe/Berlin'
  SERVERS = ENV['SERVERS'] || 1

  NETWORK = IPAddr.new(NETWORK_BASE).mask(NETWORK_MASK)
  DNS_PROVIDER = "sslip.io"

  ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip

  config.vm.box = BOX.to_s
  config.vm.box_check_update = false
  # vagrant plugin install vagrant-vbguest
  #config.vm.synced_folder "data", "/data", :mount_options => ["dmode=777", "fmode=666"]
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provider Settings
  config.vm.provider "virtualbox" do |vb|
    vb.memory = MEM.to_s
    vb.cpus = CPUS.to_s
    # macos 100% CPU fix
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  (1..SERVERS).each do |i|
    config.vm.define "server-#{i}" do |subconfig|
      #subconfig.vm.box = BOX.to_s
      PORT = TCPServer.new('localhost', 0).addr[1]
      HOST_IP = NETWORK | IPAddr.new("0.0.0.#{i + 10}")
      HOST_NAME = "#{HOST_IP.to_s.gsub('.','-')}.#{DNS_PROVIDER}"
      subconfig.vm.hostname = HOST_NAME.to_s
      subconfig.vm.network :private_network, ip: HOST_IP.to_s
      subconfig.vm.network :forwarded_port, guest: 80, host: PORT.to_s

      subconfig.vm.provision "shell", path: BOOTSTRAP.to_s, args: [TIMEZONE.to_s]
      subconfig.vm.provision "shell", inline: <<-SHELL
        grep -sq "#{ssh_pub_key}" /home/vagrant/.ssh/authorized_keys || echo "#{ssh_pub_key}" >> /home/vagrant/.ssh/authorized_keys
      SHELL

      # Show info
      subconfig.vm.post_up_message = "Server is available at http://localhost:#{PORT}/ or http://#{HOST_NAME}/"
    end
  end

end
