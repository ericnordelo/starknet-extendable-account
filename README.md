# Abstract

This is a POC for an account that, leveraging account abstraction, can be extended through plugins without needing to modify the account code itself.

# Rationale

With native Account Abstraction, starknet account contracts are powerful and can implement potentially any logic, but
designing an account for handling every potential use case is unpractical, and even with multi-call patterns by
default, there are always cases where on-chain logic must be added to accomplish an objective.

For example, we have the `ERC20` token allowance mechanism, with the well-known [front-running potential issue](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.m9fhqynw2xvt) of the
`approve` function. A solution as suggested in the [EIP-20](https://github.com/ethereum/ercs/blob/master/ERCS/erc-20.md#approve) itself is to set the allowance first to 0 before setting another value for the same spender. This could be easily implemented in regular accounts with a multi-call pattern, but you will be writing twice to storage, which is not ideal. In Ethereum, token implementors at some point added the `increaseAllowance` and `decreaseAllowance` functions, which seemed to address the issue without needing to approve 0 first, but these functions being not part of the standard itself, had some [drawbacks that made OpenZeppelin remove it](https://github.com/OpenZeppelin/openzeppelin-contracts/issues/4583) from its ERC20 implementation. What is left then? Multi-call approach? Well, with extendable accounts we can make a `safe_allowance` plugin providing the `increaseAllowance` and `decreaseAllowance` implementations, without these needing to be part of the `ERC20` token implementation, and this allows us to "safely" call approve without needing to approve 0 first.

This example can be extended to provide support for any logic we may need without modifying the account, just by registering plugins. Another case could be the [UDC](https://docs.starknet.io/documentation/architecture_and_concepts/Smart_Contracts/universal-deployer/), which is currently deploying from the UDC address itself when it could be easily implemented as a plugin, and then the account could deploy through it without needing to have the deployment logic in the source code.

NOTE: ExtendableAccount leverages `library_calls` for using external-implemented-logic. The allowed plugins list should be whitelisted because bad plugins can do anything to the account if they are used. The provided example uses a SafePlugin trait implementation requirement for handling the whitelist.