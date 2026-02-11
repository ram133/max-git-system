import {execSync} from "child_process";import {log} from "./logger.js";export function run(c){log("RUN: "+c);return execSync(c,{stdio:"pipe"}).toString().trim();}
