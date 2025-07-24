FROM odoo:14
USER root
COPY ./config/servicedesk.conf /etc/odoo/odoo.conf
COPY ./addons /mnt/extra-addons
COPY ./core /mnt/core
COPY ./entrypoint.sh /
COPY ./wait-for-psql.py /usr/local/bin/wait-for-psql.py
RUN chown odoo:odoo /entrypoint.sh /usr/local/bin/wait-for-psql.py
RUN chmod +x /entrypoint.sh 
RUN chmod +x /usr/local/bin/wait-for-psql.py

RUN chown -R odoo:odoo /mnt/extra-addons /mnt/core /etc/odoo
ENV ODOO_RC=/etc/odoo/odoo.conf

USER odoo
ENTRYPOINT ["/entrypoint.sh"]
# CMD ["odoo"]