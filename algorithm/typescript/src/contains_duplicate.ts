export function contains_duplicate(nums: number[]): boolean {
    return new Set<number>(nums).size !== nums.length;
}

export function contains_duplicate2(nums: number[]): boolean {
    nums = nums.sort()
    for (let i = 0; i < nums.length - 1; i++) {
        if (nums[i] === nums[i + 1]) {
            return true;
        }
    }
    return false;
}

export function contains_duplicate3(nums: number[]): boolean {
    const set = new Set<number>();
    for (const num of nums) {
        if (set.has(num)) {
            return true;
        }
        set.add(num);
    }
    return false;
}

