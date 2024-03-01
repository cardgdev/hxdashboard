package dashboard;

import util.Coroutine.StartCoroutine;
import util.Coroutine.OnCoroutine;
import util.Coroutine.KillCoroutine;
import util.Coroutine.IsCoroutineRunning;
import dashboard.HxDashboard.HxDashboardProcess;
import haxe.display.Display.Package;
import hxd.Timer;
import haxe.ui.Toolkit;
import hl.UI.Button;
import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class HxDashboardView extends VBox {
    var procs: Array<HxDashboardProcess>;

    public function new(procs: Array<HxDashboardProcess>) {
        super();
        this.procs = procs;
        for (process in this.procs) {
            tv4.dataSource.add(createProcItem(process));
        }
        tv4.onComponentEvent = (e) -> {
            if(e.source.id == "colA"){
                switch procs[e.itemIndex] {
                    case Process(name, onStart, coroutine): {
                        var coroutineTag = "C" + e.itemIndex;
                        if(IsCoroutineRunning(coroutineTag)){
                            KillCoroutine(coroutineTag);
                            (cast e.source: haxe.ui.components.Button).icon = "play.png";
                            (cast e.source: haxe.ui.components.Button).backgroundColor = 0x93C572;
                        }
                        else{
                            (cast e.source: haxe.ui.components.Button).icon = "pause.png";
                            (cast e.source: haxe.ui.components.Button).backgroundColor = 0xC70039;
                            OnCoroutine(coroutineTag, Completed, () -> {
                                (cast e.source: haxe.ui.components.Button).icon = "play.png";
                                (cast e.source: haxe.ui.components.Button).backgroundColor = 0x93C572;
                                return false;
                            });
                                                        
                            var a = onStart();
                            StartCoroutine(coroutineTag, a, coroutine);
                        }
                        
                    }
                }
            }
        };
    }

    function createProcItem(proc: HxDashboardProcess) {
        var d:Dynamic = {};
        switch proc {
            case Process(name, onStart, coroutine): {
                d.colB = name;
            }
        }
        return d;
    }

}