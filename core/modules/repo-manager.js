import {gh} from "../utils/github-api.js";import {log}from"../utils/logger.js";const ORG="ram133";
export function createRepo(n){log("Creating repo "+n);gh(`repo create ${ORG}/${n} --public --confirm`);}
export function setDefaultBranch(n,b="main"){log("Setting default branch");gh(`api repos/${ORG}/${n} -X PATCH -F default_branch=${b}`);}
