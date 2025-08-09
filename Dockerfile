FROM odoo:18
USER root
# COPY ./config/odoo.conf /etc/odoo/odoo.conf
COPY ./addons/requirements.txt /
COPY ./addons /mnt/extra-addons
RUN pip3 install -r requirements.txt --no-cache-dir --break-system-packages --upgrade --ignore-installed
RUN pip3 install pandas --no-cache-dir --break-system-packages --upgrade --ignore-installed

COPY --chmod=777 --chown=odoo:odoo entrypoint.sh /entrypoint.sh
# RUN chown odoo:odoo /entrypoint.sh
# RUN chmod +x /entrypoint.sh 

RUN chown -R odoo:odoo /mnt/extra-addons 
RUN chown -R odoo:odoo /var/lib/odoo
# ENV ODOO_RC=/etc/odoo/odoo.conf

# USER odoo
ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
