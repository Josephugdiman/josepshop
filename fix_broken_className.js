const fs = require('fs');
const path = require('path');

const filePath = path.join(process.cwd(), 'src', 'pages', 'Dashboard.jsx');
let content = fs.readFileSync(filePath, 'utf8');

// The specific malformed line found in view_file:
// 1615:               className={p.1.5 transition hover:bg-slate-700/50 rounded }
// Wait, the view_file showed exactly: className={p.1.5 transition hover:bg-slate-700/50 rounded }
// Let's use a very specific replacement for that block.

const targetBlock = `            <button
              onClick={(e) => {
                e.stopPropagation();
                handleRenewVendor(row);
              }}
              className={p.1.5 transition hover:bg-slate-700/50 rounded }
              title="Renew Vendor"
            >
              <RotateCcw className="w-4 h-4" />
            </button>`;

const fixedBlock = `            <button
              onClick={(e) => {
                e.stopPropagation();
                handleRenewVendor(row);
              }}
              className="p-1.5 transition hover:bg-slate-700/50 rounded text-slate-400 hover:text-emerald-400"
              title="Renew Vendor"
            >
              <RotateCcw className="w-4 h-4" />
            </button>`;

// Try direct replacement
let newContent = content.replace(targetBlock, fixedBlock);

if (newContent === content) {
  console.log("BLOCK_NOT_FOUND_TRYING_SUBSTRING");
  // Try just the broken line
  newContent = content.replace('className={p.1.5 transition hover:bg-slate-700/50 rounded }', 'className="p-1.5 transition hover:bg-slate-700/50 rounded text-slate-400 hover:text-emerald-400"');
}

if (newContent !== content) {
  fs.writeFileSync(filePath, newContent);
  console.log("CLEANUP_SUCCESS");
} else {
  console.log("CLEANUP_FAILED_NOTHING_REPLACED");
}
