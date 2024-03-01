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
        var app = new HxDashboard([
            HxDashboardUtils.createCMDProcess("Generate DB Types", "hl D:\\code\\baugzburg\\b-dbops\\run.hl")
        ]);
    }
}


