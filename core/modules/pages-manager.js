import {gh}from"../utils/github-api.js";import{log}from"../utils/logger.js";const ORG="ram133";
export function enablePages(n){log("Enabling Pages");gh(`api repos/${ORG}/${n}/pages -X PUT -f source='{"branch":"main","path":"/"}'`);}
