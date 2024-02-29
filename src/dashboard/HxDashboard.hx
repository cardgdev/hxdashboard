package dashboard;

import util.Coroutine;
import util.Coroutine.CoroutineSystem;
import haxe.ui.HaxeUIApp;
import haxe.ui.Toolkit;

class HxDashboard extends HaxeUIApp {
    
    public function new(procs: Array<HxDashboardProcess>) {
        super();
        ready(function() {
            addComponent(new HxDashboardView(procs));
            start();
        });
    }

    public override function onHeapsUpdate(dt:Float) {
        super.onHeapsUpdate(dt);
        CoroutineSystem.update(dt);
    }

}

enum HxDashboardProcess {
    Process<T>(name: String, onStart: () -> T, coroutine: Coroutine<T>);
}