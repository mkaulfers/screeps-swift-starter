import JavaScriptEventLoop
import JavaScriptKit

public enum ScreepsRuntime {
    private static var retainedLoopClosure: JSClosure?

    public static func install(loop: @escaping () -> Void) {
        #if arch(wasm32)
        JavaScriptEventLoop.installGlobalExecutor()
        #else
        if #available(macOS 14.0, *) {
            JavaScriptEventLoop.installGlobalExecutor()
        }
        #endif

        retainedLoopClosure = JSClosure { _ in
            loop()
            return .undefined
        }

        JSObject.global.__swiftScreepsLoop = .object(retainedLoopClosure!)
        JSObject.global.__swiftScreepsReady = .boolean(true)
    }
}
