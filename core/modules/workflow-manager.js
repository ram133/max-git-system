import fs from "fs";import path from "path";import {gh}from"../utils/github-api.js";import{log}from"../utils/logger.js";const ORG="ram133";
export async function installWorkflow(r,f){log(`Installing workflow ${f} into ${r}`);const t=`temp-${r}`;gh(`repo clone ${ORG}/${r} ${t}`);
const w=path.join(t,".github","workflows");fs.mkdirSync(w,{recursive:true});
fs.copyFileSync(path.join("workflows",f),path.join(w,f));
process.chdir(t);gh("status");gh("commit -am 'Install workflow' || true");gh("push");process.chdir("..");
fs.rmSync(t,{recursive:true,force:true});}
