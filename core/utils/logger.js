import fs from "fs";export function log(m){if(!fs.existsSync("logs"))fs.mkdirSync("logs");fs.appendFileSync("logs/system.log",`[${new Date().toISOString()}] ${m}\n`);}
