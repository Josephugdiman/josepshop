const fs = require('fs');
const path = require('path');

const filePath = path.join(process.cwd(), 'src', 'pages', 'Dashboard.jsx');
let content = fs.readFileSync(filePath, 'utf8');

// The line is: className={p-1.5 transition hover:bg-slate-700/50 rounded }
// But view_file showed: className={p.1.5 transition hover:bg-slate-700/50 rounded }
// It might be - or . or something else. Let's use a regex to be safe.

const brokenRegex = /className=\{p[-.]1\.5 transition hover:bg-slate-700\/50 rounded \}/g;
const fixedClassName = 'className="p-1.5 transition hover:bg-slate-700/50 rounded text-slate-400 hover:text-emerald-400"';

let newContent = content.replace(brokenRegex, fixedClassName);

// Also fix encoding just in case
newContent = newContent.replace(/Ã¢Å“â€¦/g, '✅');

if (newContent !== content) {
    fs.writeFileSync(filePath, newContent);
    console.log("SUCCESS_CLEANUP");
} else {
    // Try one more time with a very loose match if the above failed
    console.log("REGEX_MATCH_FAILED_TRYING_SUBSTRING");
    const looseTarget = 'className={p';
    const endOfBroken = 'rounded }';
    const sIndex = content.indexOf(looseTarget);
    const eIndex = content.indexOf(endOfBroken, sIndex);

    if (sIndex !== -1 && eIndex !== -1 && (eIndex - sIndex) < 100) {
        const finalContent = content.substring(0, sIndex) + fixedClassName + content.substring(eIndex + endOfBroken.length);
        fs.writeFileSync(filePath, finalContent);
        console.log("SUCCESS_CLEANUP_LOOSE");
    } else {
        console.log("FULLY_FAILED", { sIndex, eIndex });
    }
}
