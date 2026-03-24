import fs from 'fs';
import * as XLSX from 'xlsx';

const data = [
  {
    permit_number: 'PTO-2026-0001',
    business_name: 'Sample General Merchandise',
    owner_name: 'Juan Dela Cruz'
  },
  {
    permit_number: 'PTO-2026-0002',
    business_name: 'Fresh Vegetables Stand',
    owner_name: 'Maria Santos'
  },
  {
    permit_number: 'PTO-2026-0003',
    business_name: 'City Meat Shop',
    owner_name: 'Pedro Reyes'
  }
];

// 1. Write CSV
let csvData = 'permit_number,business_name,owner_name\n';
data.forEach(row => {
   csvData += `${row.permit_number},${row.business_name},${row.owner_name}\n`;
});
fs.writeFileSync('renewal_template.csv', csvData);

// 2. Write XLSX
const ws = XLSX.utils.json_to_sheet(data);
const wb = XLSX.utils.book_new();
XLSX.utils.book_append_sheet(wb, ws, 'Renewals');
XLSX.writeFile(wb, 'renewal_template.xlsx');

console.log('Template files generated successfully.');
