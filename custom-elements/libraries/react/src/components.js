import React, { Component } from 'react';
import 'ce-without-children';

export class ComponentWithoutChildren extends Component {
    render() {
        return (
            <div>
                <ce-without-children ref={(el) => this.wc = el}></ce-without-children>
            </div>
        );
    }
}


export class ComponentWithChildren extends Component {
    render() {
        return (
            <div>
                <ce-with-children ref={(el) => this.wc = el}></ce-with-children>
            </div>
        );
    }
}

export class ComponentWithChildrenRerender extends Component {
    constructor() {
        super();
        this.state = { count: 1 };
    }
    componentDidMount() {
        Promise.resolve().then(_ => this.setState({ count: this.state.count += 1 }));
    }
    componentWillUnmount() {
        clearInterval(this.interval);
    }
    render() {
        const { count } = this.state;
        return (
            <div>
                <ce-with-children ref={(el) => this.wc = el}>{count}</ce-with-children>
            </div>
        );
    }
}

export class ComponentWithDifferentViews extends Component {
    constructor () {
      super();
      this.state = { showWC: true };
    }
    toggle() {
      this.setState({ showWC: !this.state.showWC });
    }
    render () {
      const { showWC } = this.state;
      return (
        <div>
          {showWC ? (
            <ce-with-children ref={(el) => this.wc = el}></ce-with-children>
          ) : (
            <div ref="dummy">Dummy view</div>
          )}
        </div>
      );
    }
  }


  export class ComponentWithProperties extends Component {
    render () {
      const data = {
        bool: true,
        num: 42,
        str: 'React',
        arr: ['R', 'e', 'a', 'c', 't'],
        obj: { org: 'facebook', repo: 'react' }
      };
      return (
        <div>
          <ce-with-properties ref={(el) => this.wc = el}
            bool={data.bool}
            num={data.num}
            str={data.str}
            arr={data.arr}
            obj={data.obj}
          ></ce-with-properties>
        </div>
      );
    }
  }

  