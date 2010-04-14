package aspects;

import net.intensicode.util.Log;
import net.intensicode.util.Timing;

aspect ExecutionTiming {
    pointcut allClasses(): within(net.intensicode.droidshock..*) && !within(net.intensicode.util.*);
    pointcut allConstructors(): allClasses() && execution(new(..));
    pointcut allMethods(): allClasses() && execution(* *(..));

    before (): allConstructors() {
        Timing.start(thisJoinPointStaticPart.getSignature());
    }
    after(): allConstructors() {
        Timing.end(thisJoinPointStaticPart.getSignature());
    }

    before (): allMethods() {
        Timing.start(thisJoinPointStaticPart.getSignature());
    }
    after(): allMethods() {
        Timing.end(thisJoinPointStaticPart.getSignature());
    }
}
