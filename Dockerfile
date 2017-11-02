FROM infotechsoft/htcondor:8.6

ARG PEGASUS_VERSION=4.8.0
ENV PEGASUS_SERVER_HOST	localhost
ENV PEGASUS_SERVER_PORT	5000

LABEL name="infotechsoft/pegasus" \
	vendor="INFOTECH Soft, Inc." \
	version="${PEGASUS_VERSION}" \
	release-date="2017-11-02" \
	maintainer="Thomas J. Taylor <thomas@infotechsoft.com>"

# Pegasus-WMS
RUN curl -o /etc/yum.repos.d/pegasus.repo https://download.pegasus.isi.edu/wms/download/rhel/7/pegasus.repo && \
	yum -y install pegasus-${PEGASUS_VERSION} && \
	yum -y clean all

RUN export PYTHONPATH=`pegasus-config --python` && \
	export PERL5LIB=`pegasus-config --perl` && \
	export CLASSPATH=`pegasus-config --classpath`


CMD condor_master -f -t & && \
	pegasus-service --host $PEGASUS_SERVER_HOST --port $PEGASUS_SERVER_PORT