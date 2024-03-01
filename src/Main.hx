package ;

import dashboard.HxDashboardUtils;
import sys.io.Process;
import haxe.display.Display.Package;
import haxe.ui.containers.TableView;
import haxe.Timer;
import haxe.ui.Toolkit;
import dashboard.HxDashboard;
import haxe.ui.HaxeUIApp;

class Main {
    public static function main() {


        new HxDashboard([
            HxDashboardUtils.createCMDProcess("Run cmd process", "hl command.hl"),
            getCustomProcess()    
        ]);
    }

    public static function getCustomProcess(): HxDashboardProcess {
        return Process("Run custom process", 
        () -> {
            var payload = {data: startWork()}; //any type
            return payload;
        }, 
        (payload, op) -> {
            switch op {
                case OnFrame(dt): {
                    if(payload.data.isDone()){
                        return Complete;
                    }
                    return WaitNextFrame;
                }
                case Kill: {
                    payload.data.kill();
                    return Killed;
                }
            }
        });
    }
}


