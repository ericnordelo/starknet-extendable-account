use starknet::account::Call;
use ex_account::library_call::LibraryCall;

#[starknet::interface]
trait IExtendableAccount<TContractState> {
    fn __execute__(
        self: @TContractState, calls: Array<Call>, library_calls: Array<LibraryCall>
    ) -> (Array<Span<felt252>>, Array<Span<felt252>>);
    fn __validate__(
        self: @TContractState, calls: Array<Call>, library_calls: Array<LibraryCall>
    ) -> felt252;
    fn is_valid_signature(
        self: @TContractState, hash: felt252, signature: Array<felt252>
    ) -> felt252;
}
