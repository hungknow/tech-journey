import { contains_duplicate } from "./contains_duplicate";

test("test contains_duplicates", () => {
  let testCases: [number[], boolean][] = [
    [[], false],
    [[1, 2, 3, 4, 1], true],
    [[1, 2, 3, 4, 5], false],
    [[1, 2, 1, 2, 5], true],
  ];

  testCases.forEach(([input, expected]) => {
    expect(contains_duplicate(input)).toEqual(expected);
  });
});
