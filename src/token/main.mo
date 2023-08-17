import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Hash "mo:base/Hash";

actor Token {

    let owner : Principal = Principal.fromText("uysb6-z7ypk-67qk5-rui2z-o5kek-4xum6-wojp4-v7azf-wwkk2-6imhp-uae");
    let totalSupply : Nat = 10000000000;
    let symbol : Text = "JOHN";

    private stable var balanceEntries : [(Principal, Nat)] = [];

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

    public query func balanceOf(who : Principal) : async Nat {

        let balance : Nat = switch (balances.get(who)) {
            case null 0;
            case (?result) result;
        };

        return balance;
    };

    public query func getSymbol() : async Text {
        return symbol;
    };

    public shared (msg) func payOut() : async Text {

        Debug.print(debug_show (msg.caller));

        if (balances.get(msg.caller) == null) {
            let amount = 10000;
            let result = await transfer(msg.caller, amount);

            return result;
        } else {
            return "already Clamied";
        };

    };

    public shared (msg) func transfer(to : Principal, amount : Nat) : async Text {
        let from_balance = await balanceOf(msg.caller);
        if (from_balance >= amount) {
            let newFromBalance : Nat = from_balance -amount;
            balances.put(msg.caller, newFromBalance);

            let to_balance = await balanceOf(to);
            let newToBalance = to_balance + amount;
            balances.put(to, newToBalance);
            return "success";
        } else {
            return "Inseffisent funds ";
        };
    };

    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        };

    };

};
