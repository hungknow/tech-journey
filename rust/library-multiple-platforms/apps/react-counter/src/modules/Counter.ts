import { counter_process_event, counter_view } from "lib1/lib1";
import {
  CounterEvent,
  CounterViewModel,
  CounterEffect,
  CounterEffectVariantRender,
  Request,
} from "shared_types/types/shared_types";
import {
  BincodeDeserializer,
  BincodeSerializer,
} from "shared_types/bincode/mod";
import { Dispatch, SetStateAction } from "react";

export class Counter {
  setState: Dispatch<SetStateAction<CounterViewModel>>;

  constructor(
    setState: Dispatch<SetStateAction<CounterViewModel>>
  ) {
    this.setState = setState;
  }

  update(event: CounterEvent) {
    console.log("event", event);

    const serializer = new BincodeSerializer();
    event.serialize(serializer);

    const effects = counter_process_event(serializer.getBytes());

    const requests = deserializeRequests(effects);
    for (const { uuid, effect } of requests) {
      this.processEffect(uuid, effect);
    }
  }

  view(): CounterViewModel {
    return deserializeView(counter_view());
  }

  processEffect(uuid: number[], effect: CounterEffect) {
    console.log("effect", effect);

    switch (effect.constructor) {
      case CounterEffectVariantRender:
        this.setState(deserializeView(counter_view()));
        break;
    }
  }
}

function deserializeView(bytes: Uint8Array): CounterViewModel {
  return CounterViewModel.deserialize(new BincodeDeserializer(bytes));
}

function deserializeRequests(effects: Uint8Array): Request[] {
  const deserializer = new BincodeDeserializer(effects);
  const len = deserializer.deserializeLen();
  const requests: Request[] = [];
  for (let i = 0; i < len; ++i) {
    const request = Request.deserialize(deserializer);
    requests.push(request);
  }
  return requests;
}
