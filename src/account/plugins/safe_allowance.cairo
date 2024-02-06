/// Plugin for extensable accounts, allowing to increase and decrease allowance
/// in ERC20 tokens.
#[starknet::contract]
mod SafeAllowance {
    use openzeppelin::token::erc20::dual20::DualCaseERC20Trait;
    use openzeppelin::token::erc20::dual20::DualCaseERC20;
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[abi(per_item)]
    #[generate_trait]
    impl External of ExternalTrait {
        /// Increases the allowance granted from the caller to `spender` by `added_value`.
        #[external(v0)]
        fn increase_allowance(
            ref self: ContractState,
            spender: ContractAddress,
            added_value: u256,
            token: ContractAddress
        ) -> bool {
            let dispatcher = DualCaseERC20 { contract_address: token };
            let caller = get_caller_address();
            dispatcher.approve(spender, dispatcher.allowance(caller, spender) + added_value);
            true
        }

        /// Decreases the allowance granted from the caller to `spender` by `subtracted_value`.
        #[external(v0)]
        fn decrease_allowance(
            ref self: ContractState,
            spender: ContractAddress,
            subtracted_value: u256,
            token: ContractAddress
        ) -> bool {
            let dispatcher = DualCaseERC20 { contract_address: token };
            let caller = get_caller_address();
            dispatcher.approve(spender, dispatcher.allowance(caller, spender) - subtracted_value);
            true
        }
    }
}
