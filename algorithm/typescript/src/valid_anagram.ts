export function valid_anagram(s: string, t: string): boolean {
  if (s.length !== t.length) return false;
  const map = Array(26).fill(0);
  const firstLetter = 'a'.charCodeAt(0);
  for (let i = 0; i < s.length; i++) {
    map[s.charCodeAt(i) - firstLetter]++;
    map[t.charCodeAt(i) - firstLetter]--;
  }
  for (const value of map) {
    if (value !== 0) return false;
  }
  return true;
}
