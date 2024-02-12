import { valid_anagram } from "./valid_anagram";

test("test valid_anagram", () => {
  let testCases: [string, string, boolean][] = [
    ["anagram", "nagaram", true],
    ["rat", "car", false],
    ["listen", "silent", true],
    ["hello", "world", false],
  ];

  testCases.forEach(([s, t, expected]) => {
    expect(valid_anagram(s, t)).toEqual(expected);
  });
});