#!/bin/bash

if [ $UID != 0 ]; then
    echo "This script must be run as root."
    exit 1
fi                        

# INSTALL ALL NECESARY PACKAGES
apt-get install postgresql python python-psycopg2 python-reportlab \
python-egenix-mxdatetime python-tz python-pychart python-mako \
python-pydot python-lxml python-vobject python-yaml python-dateutil \
python-pychart python-pydot python-webdav python-cherrypy3 python-formencode python-pybabel \
python-simplejson python-pyparsing apache2     

# ADDING SYSTEM USER "OPENERP" AND POSGRESQL USER "OPENERP" WITH PASSWORD "OPENERP"
adduser --system --home=/opt/openerp --group openerp 
su - postgres -c "createuser --createdb --username postgres --no-createrole --no-superuser openerp"    
su - postgres -c "psql -c \"alter user openerp with password 'openerp';\""    

# UNCOMPRESS DATA INTO /OPT
tar xpf openerp.tar.bz2 -C /opt/  
chown -R openerp: /opt/openerp

# COPY CONFIG AND INIT FILES
cp -R etc/* /etc              
chown openerp:root /etc/openerp-*
chmod 640 /etc/openerp-*
chown root: /etc/init.d/openerp-*   
chmod 755 /etc/init.d/openerp-* 

# MAKE SELF-BOOTABLE          
update-rc.d openerp-server defaults
update-rc.d openerp-web defaults

# DIR LOGS
mkdir /var/log/openerp
chown openerp:root /var/log/openerp    

# RESTART EVERYTHING. OPENERP IS INSTALLED      
/etc/init.d/postgresql-8.4 restart
/etc/init.d/openerp-server restart
/etc/init.d/openerp-web restart     

#APACHE CONFIGURATION
a2enmod ssl proxy_http headers rewrite         


