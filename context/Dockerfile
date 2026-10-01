######################################
# docker-smw-lablsk                  #
######################################

ARG OPENRESEARCH_STACK=1.39.17-003
FROM ghcr.io/tibhannover/openresearch-stack:${OPENRESEARCH_STACK}

# hadolint ignore=DL3008,DL3015
RUN \
	### install required apt packages
	#
	# graphviz 1)
	#
	# 1) External_Data Graphviz
	#
	apt-get update && \
	apt-get install -y graphviz && \
	rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3066
USER www-data
RUN \
    ### ConfirmAccount
    # last version that supports 1.39
    # TODO: This is already part of OR-Stack but with a different version!
    # get-github-extension.sh ConfirmAccount 5c8c0ca2fc0fd27d2388b407de7f7a7fac6e9e9b wikimedia/mediawiki-extensions-ConfirmAccount && \
    #
    #
    ### KnowledgeGraph (2026-01-20)
    ## 3.0.2 is the last version that supports MW 1.39
    get-github-extension.sh KnowledgeGraph 3.0.2 SemanticMediaWiki/KnowledgeGraph && \
    #
    #
    ### ELNSMWAdapterUI (2026-09-30)
    ## Installed but not loaded by default; wikis enable it in their own settings
    get-github-extension.sh ELNSMWAdapterUI 2.0.1 TIBHannover/eln-smw-adapter-ui && \
    #
    #
    ### PluggableAuth (2024-02-23)
    ## Required by OpenIDConnect. Installed but not loaded by default; wikis enable it in their own settings
    get-github-extension.sh PluggableAuth 7.1.0 && \
    #
    #
    ### OpenIDConnect (REL1_39-5ae6ab2)
    ## Installed but not loaded by default; wikis enable it in their own settings
    get-extension.sh OpenIDConnect https://github.com/gesinn-it/extdist.wmflabs.org/raw/main/dist/extensions/OpenIDConnect-REL1_39-5ae6ab2.tar.gz && \
    COMPOSER=composer.local.json composer config --json --merge extra.merge-plugin.include '["extensions/OpenIDConnect/composer.json"]'

RUN composer-update.sh
# hadolint ignore=DL3002,DL3066
USER root

######################################
# add LabLSK settings                #
######################################
COPY --chown=www-data:www-data LocalSettings.Include.php /var/www/html/.
COPY --chown=www-data:www-data LocalSettings.LabLSK /var/www/html/LocalSettings.LabLSK

# Global styles
#COPY mediawiki-global-styles/styles/* /var/www/html/resources/src/mediawiki.gesinn-it.global.styles/

#COPY media /var/www/html/_custom/media
#COPY styles /var/www/html/_custom/styles
######################################
# add style files                    #
######################################
# COPY --chown=www-data:www-data mediawiki-global-styles/styles/* /var/www/html/resources/src/mediawiki.gesinn-it.global.styles/
COPY --chown=www-data:www-data media /var/www/html/resources/src/mediawiki.lablsk.media/
COPY --chown=www-data:www-data styles/* /var/www/html/resources/src/mediawiki.lablsk.styles/

######################################
# run as http://localhost:8080		 #
######################################
ENV WIKI_DOMAIN=localhost
ENV WIKI_PORT=8080

######################################
# set smw-lablsk version      		 #
######################################
ARG SMW_LABLSK_VERSION=3.3.0
RUN echo $SMW_LABLSK_VERSION > smw-lablsk-version.txt && \
    echo "\$wgSmwLabLskVersion = '$SMW_LABLSK_VERSION';" >> LocalSettings.Include.php
