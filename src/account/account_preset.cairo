#[starknet::contract(account)]
mod Account {
    use ex_account::account::AccountComponent;
    use ex_account::account::utils::SafePlugins;
    use openzeppelin::introspection::src5::SRC5Component;

    component!(path: AccountComponent, storage: account, event: AccountEvent);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // SafePlugins impl
    impl SafePluginsImpl of SafePlugins {
        fn get() -> Felt252Dict<bool> {
            let mut safe_plugins: Felt252Dict = Default::default();
            let safe_allowance_class_hash = '...';
            safe_plugins.insert(safe_allowance_class_hash, true);
            safe_plugins
        }
    }

    // Account
    #[abi(embed_v0)]
    impl ExtendableAccountImpl =
        AccountComponent::ExtendableAccountImpl<ContractState>;
    #[abi(embed_v0)]
    impl ExtendableAccountCamelOnlyImpl =
        AccountComponent::ExtendableAccountCamelOnlyImpl<ContractState>;
    #[abi(embed_v0)]
    impl PublicKeyImpl = AccountComponent::PublicKeyImpl<ContractState>;
    #[abi(embed_v0)]
    impl PublicKeyCamelImpl = AccountComponent::PublicKeyCamelImpl<ContractState>;
    #[abi(embed_v0)]
    impl DeclarerImpl = AccountComponent::DeclarerImpl<ContractState>;
    #[abi(embed_v0)]
    impl DeployableImpl = AccountComponent::DeployableImpl<ContractState>;
    impl AccountInternalImpl = AccountComponent::InternalImpl<ContractState>;

    // SRC5
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        account: AccountComponent::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        AccountEvent: AccountComponent::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState, public_key: felt252) {
        self.account.initializer(public_key);
    }
}
