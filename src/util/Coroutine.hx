package util;

class CoroutineSystem {
    public static var coroutines: Array<CoroutineContext> = [];
    static var coroutineSubscriptions: Array<CoroutineSubscription> = [];

    public static function add<T>(tag: String, args: Dynamic, c: Coroutine<T>) {
        coroutines.push(new CoroutineContext(tag, c, args));
    }

    static var contextsForRemoval: Array<CoroutineContext> = [];
    static var subscriptionsForRemoval: Array<CoroutineSubscription> = [];
    public static function update(dt: Float) {
        contextsForRemoval = [];
        subscriptionsForRemoval = [];
        for (context in coroutines) {
            if(!context.update(dt)){
                contextsForRemoval.push(context);
            }
        }
        for (context in contextsForRemoval) {
            for (subscription in coroutineSubscriptions) {
                switch subscription {
                    case Subscription(tag, Completed, cb) if (tag == context.tag): {
                        if(!cb()){
                            subscriptionsForRemoval.push(subscription);
                        }
                    }
                    default:
                }
            }
            coroutines.remove(context);
        }
        for (subscription in subscriptionsForRemoval) {
            coroutineSubscriptions.remove(subscription);
        }
    }

    public static function kill(tag: String) {
        for (context in coroutines) {
            if(context.tag == tag){
                context.kill();
            }
        }
    }

    public static function subscribe(tag: String, event: CoroutineEvent, cb: () -> Bool) {
        coroutineSubscriptions.push(Subscription(tag, event, cb));
    }

}

var IsCoroutineRunning = (coroutineTag: String) -> {
    for (context in CoroutineSystem.coroutines) {
        if(context.tag == coroutineTag){
            return !context.isComplete;
        }
    }
    return false;
}

var KillCoroutine = (coroutineTag: String) -> {
    CoroutineSystem.kill(coroutineTag);
}

var OnCoroutine = (coroutineTag: String, event: CoroutineEvent, cb: () -> Bool) -> {
    CoroutineSystem.subscribe(coroutineTag, event, cb);
}

function StartCoroutine<T>(tag: String, arg: T, cr: Coroutine<T>) {
    CoroutineSystem.add(tag, arg, cr);
}

class CoroutineContext {
    public var tag: String;
    public var coroutine: Coroutine<Dynamic>;
    public var args: Dynamic;
    public var isComplete: Bool = false;

    public function new(tag: String, coroutine: Coroutine<Dynamic>, args: Dynamic) {
        this.tag = tag;
        this.coroutine = coroutine;
        this.args = args;
    }

    public function update(dt: Float): Bool {
        if(isComplete){
            return false;
        }
        switch coroutine(args, OnFrame(dt)) {
            case WaitNextFrame: return true;
            case Complete: {
                isComplete = true;
                return false;
            }
            default:
        }
        return false;
    }

    public function kill() {
        coroutine(args, Kill);
        isComplete = true;
    }
}

typedef Coroutine<T> = (T, CoroutineOp) -> CoroutineResult;

enum CoroutineOp {
    OnFrame(dt: Float);
    Kill;
}

enum CoroutineResult {
    WaitNextFrame;
    Complete;
    Killed;
}

enum CoroutineEvent {
    Completed;
}

enum CoroutineSubscription {
    Subscription(tag: String, event: CoroutineEvent, cb: () -> Bool);
}