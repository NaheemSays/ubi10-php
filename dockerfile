FROM registry.access.redhat.com/ubi10/php-83:latest

# Add application sources
#ADD app-src .

USER 0

# Install the dependencies
#RUN dnf config-manager --set-disabled *
#RUN dnf config-manager --set-enabled ubi10*
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
RUN dnf -y --nogpgcheck install https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-10.0-8.el10.noarch.rpm https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/os/Packages/centos-stream-repos-10.0-8.el10.noarch.rpm
RUN dnf -y update epel* centos*
#RUN /usr/bin/crb enable
RUN dnf -y install jq composer ImageMagick-libs ImageMagick mariadb-client-utils
RUN dnf -y clean all

# Run script uses standard ways to configure the PHP application
# and execs httpd -D FOREGROUND at the end
# See more in <version>/s2i/bin/run in this repository.
# Shortly what the run script does: The httpd daemon and php needs to be
# configured, so this script prepares the configuration based on the container
# parameters (e.g. available memory) and puts the configuration files into
# the appropriate places.
# This can obviously be done differently, and in that case, the final CMD
# should be set to "CMD httpd -D FOREGROUND" instead.

USER 1001
CMD /usr/libexec/s2i/run
