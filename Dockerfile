FROM infotechsoft/htcondor:8.8

ARG PEGASUS_VERSION=4.9.1
ENV PEGASUS_VERSION $PEGASUS_VERSION
ENV PEGASUS_SERVER_HOST	localhost
ENV PEGASUS_SERVER_PORT	5000
EXPOSE $PEGASUS_SERVER_PORT

LABEL name="infotechsoft/pegasus" \
	vendor="INFOTECH Soft, Inc." \
	version="${PEGASUS_VERSION}" \
	release-date="2019-03-06" \
	maintainer="Thomas J. Taylor <thomas@infotechsoft.com>"

# Pegasus-WMS
RUN curl -o /etc/yum.repos.d/pegasus.repo https://download.pegasus.isi.edu/wms/download/rhel/7/pegasus.repo && \
	yum -y update && \
	yum -y install epel-release && \
	yum -y install pegasus-${PEGASUS_VERSION} python36 && \
	yum -y clean all && \
	export PYTHONPATH=`pegasus-config --python` && \
	export PERL5LIB=`pegasus-config --perl` && \
	export CLASSPATH=`pegasus-config --classpath` && \
	pegasus-db-admin create


CMD condor_master -f -t & && \
	pegasus-service --host $PEGASUS_SERVER_HOST --port $PEGASUS_SERVER_PORT