FROM adhoc/odoo:8.0
MAINTAINER Damian Soriano <ds@ingadhoc.com>

ENV REFRESHED_AT 2014-09-13
## TODO: change this date when you want to make a new build

# Update odoo server
WORKDIR /opt/odoo/server/
RUN git checkout 8.0
RUN python setup.py install

RUN mkdir -p /opt/odoo/sources
WORKDIR /opt/odoo/sources

## Git repositories and python dependencies
## TODO:remove the one you are not going to use

# Usual adhoc generic addons
RUN git clone https://github.com/ingadhoc/odoo-addons.git
RUN git clone https://github.com/ingadhoc/odoo-argentina.git
RUN pip install geopy==0.95.1 BeautifulSoup
RUN git clone https://github.com/ingadhoc/odoo-web.git
RUN git clone https://github.com/ingadhoc/aeroo_reports.git
RUN pip install genshi==0.6.1 http://launchpad.net/aeroolib/trunk/1.0.0/+download/aeroolib.tar.gz

# Non-Usual adhoc generic addons
RUN git clone https://github.com/odoo-latam/odoo-infrastructure
RUN pip install openerp-client-lib fabric

# Adhoc specific projects

# Usual OCA addons
RUN git clone https://github.com/OCA/server-tools
RUN git clone https://github.com/OCA/web
RUN git clone https://github.com/OCA/account-financial-reporting
RUN git clone https://github.com/OCA/reporting-engine

# Non-Usual OCA addons

# Other usual addons

## Checkout last for master or specific commit for testing or release
## TODO: remove the one you are not going to use and add the missing ones

# Usual adhoc generic addons
RUN git --work-tree=/opt/odoo/sources/odoo-addons --git-dir=/opt/odoo/sources/odoo-addons/.git checkout master
RUN git --work-tree=/opt/odoo/sources/odoo-argentina --git-dir=/opt/odoo/sources/odoo-argentina/.git checkout master
RUN git --work-tree=/opt/odoo/sources/odoo-web --git-dir=/opt/odoo/sources/odoo-web/.git checkout master
RUN git --work-tree=/opt/odoo/sources/aeroo_reports --git-dir=/opt/odoo/sources/aeroo_reports/.git checkout master

# Non-Usual adhoc generic addons
RUN git --work-tree=/opt/odoo/sources/odoo-infrastructure --git-dir=/opt/odoo/sources/odoo-infrastructure/.git checkout master

# Adhoc specific projects

# Usual OCA addons
RUN git --work-tree=/opt/odoo/sources/server-tools --git-dir=/opt/odoo/sources/server-tools/.git checkout 8.0
RUN git --work-tree=/opt/odoo/sources/web --git-dir=/opt/odoo/sources/web/.git checkout 8.0
RUN git --work-tree=/opt/odoo/sources/account-financial-reporting --git-dir=/opt/odoo/sources/account-financial-reporting/.git checkout 8.0
RUN git --work-tree=/opt/odoo/sources/reporting-engine --git-dir=/opt/odoo/sources/reporting-engine/.git checkout master

# Non-Usual OCA addons

# Other usual addons

## TODO: change the path according the choosen addons
RUN sudo -H -u odoo /opt/odoo/server/odoo.py --stop-after-init -s -c /opt/odoo/odoo.conf --db_host=odoo-db --db_user=odoo-adhoc-80 --db_password=odoo-adhoc-80 --addons-path=/opt/odoo/server/openerp/addons,/opt/odoo/server/addons,/opt/odoo/sources/odoo-addons,/opt/odoo/sources/odoo-argentina,/opt/odoo/sources/odoo-web,/opt/odoo/sources/odoo-infrastructure,/opt/odoo/sources/server-tools,/opt/odoo/sources/web,/opt/odoo/sources/aeroo_reports

CMD ["sudo", "-H", "-u", "odoo", "/opt/odoo/server/odoo.py", "-c", "/opt/odoo/odoo.conf"]
