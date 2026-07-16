# -----------------------------------------------------------------------------
# Builder
# -----------------------------------------------------------------------------
FROM registry.access.redhat.com/ubi10/php-83:latest AS builder

USER 0

RUN set -eux; \
    dnf -y install \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm && \
    dnf -y --nogpgcheck install \
        https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-10.0-8.el10.noarch.rpm \
        https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/os/Packages/centos-stream-repos-10.0-8.el10.noarch.rpm && \
    dnf -y install \
        --setopt=install_weak_deps=False \
        python3 \
        python3-pip \
        jq \
        composer \
        ImageMagick \
        ImageMagick-libs \
        mariadb-client-utils \
        cairo \
        pango \
        gdk-pixbuf2 \
        libffi \
        libjpeg-turbo \
        fontconfig \
        dejavu-sans-fonts \
        shared-mime-info && \
    python3 -m venv /opt/weasyprint && \
    /opt/weasyprint/bin/pip install --upgrade pip && \
    /opt/weasyprint/bin/pip install \
        --no-cache-dir \
        "weasyprint==66.0" && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Optional if using Composer
# COPY composer.json composer.lock ./
# RUN composer install \
#     --no-dev \
#     --no-interaction \
#     --prefer-dist \
#     --optimize-autoloader

# -----------------------------------------------------------------------------
# Runtime
# -----------------------------------------------------------------------------
FROM registry.access.redhat.com/ubi10/php-83:latest

USER 0

RUN set -eux; \
    dnf -y install \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm && \
    dnf -y --nogpgcheck install \
        https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-10.0-8.el10.noarch.rpm \
        https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/os/Packages/centos-stream-repos-10.0-8.el10.noarch.rpm && \
    dnf -y install \
        --setopt=install_weak_deps=False \
        python3 \
        jq \
        ImageMagick-libs \
        mariadb-client-utils \
        cairo \
        pango \
        gdk-pixbuf2 \
        libffi \
        libjpeg-turbo \
        fontconfig \
        dejavu-sans-fonts \
        shared-mime-info && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Copy the pre-built virtual environment
COPY --from=builder /opt/weasyprint /opt/weasyprint

# Optional if Composer was run in builder
# COPY --from=builder /opt/app-root/src/vendor /opt/app-root/src/vendor

ENV PATH="/opt/weasyprint/bin:${PATH}"

# Copy application
# COPY app-src/ /opt/app-root/src/

USER 1001

CMD ["/usr/libexec/s2i/run"]
