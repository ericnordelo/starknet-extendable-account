use ex_account::library_call::LibraryCall;
use starknet::account::Call;
use starknet::ClassHash;
use starknet::SyscallResultTrait;

/// `get` returns a dictionary of the safe plugins where the
/// class hash is the key.
trait SafePlugins {
    fn get() -> Felt252Dict<bool>;
}

fn execute_safe_plugin_library_calls<+SafePlugins>(
    mut plugin_calls: Array<LibraryCall>
) -> Array<Span<felt252>> {
    let mut res = ArrayTrait::new();
    let mut safe_plugins = SafePlugins::get();
    loop {
        match plugin_calls.pop_front() {
            Option::Some(call) => {
                // Ignore calls to unsafe plugins
                if safe_plugins.get(call.to.into()) {
                    let _res = execute_single_plugin_library_call(call);
                    res.append(_res);
                }
            },
            Option::None(_) => { break (); },
        };
    };
    res
}

fn execute_single_plugin_library_call(plugin_call: LibraryCall) -> Span<felt252> {
    let LibraryCall{to, selector, calldata } = plugin_call;
    starknet::library_call_syscall(to, selector, calldata).unwrap_syscall()
}
