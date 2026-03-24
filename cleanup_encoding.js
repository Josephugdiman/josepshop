const fs = require('fs');
const path = 'c:\\xampp\\htdocs\\ugdiman-marketplacemap\\sepshop\\src\\pages\\Dashboard.jsx';

let content = fs.readFileSync(path, 'utf8');

// Replacements for common corrupted characters
const replacements = [
    { search: /Ã¢â‚¬Â¢/g, replace: '•' },
    { search: /Ã¢â€šÂ±/g, replace: '₱' },
    { search: /Ã¢Å“â€¦/g, replace: '✅' },
    { search: /Ã‚Â©/g, replace: '©' }
];

replacements.forEach(r => {
    content = content.replace(r.search, r.replace);
});

fs.writeFileSync(path, content, 'utf8');
console.log('Encoding cleanup complete.');
