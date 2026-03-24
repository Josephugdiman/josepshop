const dbTime = "2026-03-08 21:18:23";
const parsed = new Date(dbTime);
const now = new Date();
const hours = (now - parsed) / (1000 * 60 * 60);
console.log('parsed Date:', parsed);
console.log('now:', now);
console.log('hours since:', hours);
