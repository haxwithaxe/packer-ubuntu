#!/bin/sh

sed -i '/datasource_list:/d' /etc/cloud/cloud.cfg.d/99-installer.cfg
sed -i '/- None/d' /etc/cloud/cloud.cfg.d/99-installer.cfg

