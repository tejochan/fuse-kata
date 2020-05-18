#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

#Install Apache HTTP server 
package "apache2" do
   action :install
end   

#Start Apache service 
#Service starts on reboot 
service "apache2" do 
    action [:start, :enable]
end

#Write fuse.html homepage 
template "/var/www/html/fuse.html" do
	source "fuse.html.erb"
	mode "0755"
end

#Copy the default configuration file to  load fuse.html
cookbook_file '/etc/apache2/sites-available/default.conf' do
   source 'default'
   action :create
   notifies :restart, "service[apache2]"
end

#Create a directory structure for our virtual host configuration website 
directory '/var/www/html/fuse' do
  mode '0755'
  action :create
end

#Copy the apache configuration file for virtual host fuse website 
cookbook_file '/etc/apache2/sites-available/fuse.conf' do
  source 'fuse'
  mode '0755'
  action :create
end


#Write fuse.html homepage for fuse virtual host 
template "/var/www/html/fuse/fuse.html" do 
     source "fuse.html.erb"
	 mode "0644"
end 

#Execute command to enable fuse virtual host site on to our server  
execute 'a2en' do
  command 'sudo a2ensite fuse'
notifies :restart, "service[apache2]"
end
