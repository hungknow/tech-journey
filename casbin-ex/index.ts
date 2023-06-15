import { newEnforcer } from "casbin";
import { keyMatch3Func, keyMatch4Func, keyMatchFunc, regexMatchFunc } from "casbin/lib/cjs/util";

// function KeyMatch(key1: string, key2: string): boolean {
//     const i = key2.indexOf("*");
//     if (i == -1) {
//         return key1 == key2
//     }

//     if (key1.length > i) {
//         return key1.substring(0, i) == key2.substring(0, 1);
//     }
//     return key1 == key2.substring(0, i);
// }

async function check(e, sub, act, obj) {
  let message = `${sub} ${act} ${obj}`;
  if (await e.enforce(sub, obj, act)) {
    console.log(message, "ALLOWED");
  } else {
    console.log(message, "DENIED");
  }
}

async function main() {
  const e = await newEnforcer("data/model.conf", "data/policy.csv");
  e.addFunction("keyMatch", keyMatch3Func);
  e.addFunction("regexMatch", regexMatchFunc);

  let sub = "alice";
  let obj = "data1";
  let act = "read";
  await check(e, sub, act, obj);

  obj = "/alice_data/resource1";
  act = "GET";
  await check(e, sub, act, obj);

  obj = "/alice_data/resource2";
  await check(e, sub, act, obj);

  sub = 'bob';
  await check(e, sub, act, obj);

  act = 'POST';
  await check(e, sub, act, obj);
}

main();
