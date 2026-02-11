import fs from "fs";import {gh}from"../utils/github-api.js";import{log}from"../utils/logger.js";const ORG="ram133";
export function backupRepo(n){log("Backing up "+n);const d=gh(`api repos/${ORG}/${n}`);if(!fs.existsSync("backups"))fs.mkdirSync("backups");fs.writeFileSync(`backups/${n}.json`,d);}
