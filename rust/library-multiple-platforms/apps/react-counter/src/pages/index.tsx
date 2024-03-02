import Head from "next/head";
import { Inter } from "next/font/google";
import styles from "@/styles/Home.module.css";
import { useEffect, useRef, useState } from "react";
import {
  CounterEventVariantDecrement,
  CounterEventVariantIncrement,
  CounterEventVariantReset,
  CounterViewModel,
} from "shared_types/types/shared_types";
import { Counter } from "@/modules/Counter";
import init_lib1 from "lib1/lib1";

const inter = Inter({ subsets: ["latin"] });

export default function Home() {
  const [view, setView] = useState(new CounterViewModel("0"));

  const counter = useRef<Counter>(new Counter(setView));

  const initialized = useRef(false);

  useEffect(() => {
    if (!initialized.current) {
      initialized.current = true;
      init_lib1().then((lib1) => {});
    }
  }, []);

  return (
    <>
      <Head>
        <title>Counter</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main className={`${styles.main} ${inter.className}`}>
        <section className="">
          <p className="">{view.count}</p>
          <div className="buttons section is-centered">
            <button
              className="button is-primary is-danger"
              onClick={() =>
                counter.current.update(new CounterEventVariantReset())
              }
            >
              {"Reset"}
            </button>
            <button
              className="button is-primary is-success"
              onClick={() =>
                counter.current.update(new CounterEventVariantIncrement())
              }
            >
              {"Increment"}
            </button>
            <button
              className="button is-primary is-warning"
              onClick={() =>
                counter.current.update(new CounterEventVariantDecrement())
              }
            >
              {"Decrement"}
            </button>
          </div>
        </section>
      </main>
    </>
  );
}
