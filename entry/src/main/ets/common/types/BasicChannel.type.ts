type EventHandler = (val?: any) => void;

export class BasicChannel<S> {
  all: Array<EventHandler>;
  listeners: Map<string, Array<EventHandler>>;
  state: S;

  constructor(state: S) {
    this.all = [];
    this.listeners = new Map();
    this.state = state;
  }

  on(handler: EventHandler): void;
  on(eventName: string, handler: EventHandler): void;
  on(eventName: string | EventHandler, handler?: EventHandler) {
    if(typeof eventName === 'string') {
      if(!this.listeners.has(eventName)) {
        this.listeners.set(eventName, []);
      }
      this.listeners.get(eventName).push(handler);
    } else {
      this.all.push(eventName);
    }
  }

  off(handler: EventHandler): void;
  off(eventName: string, handler: EventHandler): void;
  off(eventName: string | EventHandler, handler?: EventHandler) {
    if(typeof eventName === 'string') {
      if(this.listeners.has(eventName)) {
        const handlers = this.listeners.get(eventName).filter(e => e !== handler);
        this.listeners.set(eventName, handlers);
      }
    } else {
      this.all = this.all.filter(e => e !== eventName);
    }
  }

  dispatch(eventName: string, val?: any) {
    (this.listeners.get(eventName) || []).forEach(handler => handler(val));
    this.all.forEach(handler => handler(val));
  }
}