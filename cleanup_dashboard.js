const fs = require('fs');
const path = require('path');

const filePath = path.join(process.cwd(), 'src', 'pages', 'Dashboard.jsx');
let content = fs.readFileSync(filePath, 'utf8');

// 1. Fix the broken className at line 1615 (approx)
// Finding the specific broken string
const brokenClassName = 'className={p-1.5 transition hover:bg-slate-700/50 rounded }';
const fixedClassName = 'className="p-1.5 transition hover:bg-slate-700/50 rounded"';
content = content.replace(brokenClassName, fixedClassName);

// 2. Fix the duplicated return and Layout structure
const brokenLayoutArea = /return \(\s*<Layout>\s*return \(\s*<div className="min-h-screen text-slate-900">/g;
const fixedLayoutArea = 'return (\n    <Layout>\n      <div className="min-h-screen text-slate-900 bg-slate-50">';
// Note: added bg-slate-50 for better look since logic seems to be adding a white navbar

content = content.replace(brokenLayoutArea, fixedLayoutArea);

// Also need to ensure the closing tags match. 
// If I opened <Layout> and <div...>, I need to close </div> and </Layout> at the end of the return block.

fs.writeFileSync(filePath, content);
console.log("CLEANUP_SUCCESS");
