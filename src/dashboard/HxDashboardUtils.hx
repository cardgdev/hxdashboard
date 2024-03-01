package dashboard;

import sys.io.Process;
import dashboard.HxDashboard.HxDashboardProcess;

class HxDashboardUtils {
    public static function createCMDProcess(details: String, cmd: String): HxDashboardProcess {
        return Process(details, () -> {
            return new Process(cmd, null, true);
        }, (proc, op) -> {
            switch op {
                case OnFrame(dt): {
                    if(proc.exitCode(false) == null){
                        return WaitNextFrame;
                    }
                    return Complete;
                }
                case Kill: {
                    proc.kill();
                    return Killed;
                }
            }
        });
    }
}