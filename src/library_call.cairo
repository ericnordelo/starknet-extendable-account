use starknet::ClassHash;

#[derive(Drop, Serde)]
struct LibraryCall {
    to: ClassHash,
    selector: felt252,
    calldata: Span<felt252>
}
