<?php

## -------- ELNSMWAdapterUI (local test setup) --------
wfLoadExtension( 'ELNSMWAdapterUI' );
$wgELNSMWAdapterUIServiceURL = 'http://eln-smw-adapter:5000';
$wgELNSMWAdapterUIJobStatusPath = '/eln-smw-adapter/job/';
$wgELNSMWAdapterUIAllowedELabFTWHosts = [ 'elab.example.org' ];
## ======== ELNSMWAdapterUI ========

## The service logs in on every request. With the strict default login throttle a wrong or not yet
## existing bot password locks the service out for up to an hour, so it is disabled for local testing
## (an empty list, as MediaWiki 1.39 rejects a boolean here).
$wgPasswordAttemptThrottle = [];
