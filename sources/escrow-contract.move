// Defining a Module
module escrow__addr :: escrow {

    use aptos_framework::account;
    use std::signer;

    // Declaring the state variables
    address payable buyer;
    address payable seller;
    address payable arbiter;
    map<Address, u64> TotalAmount;

    // Defining a Type
    type State = u64;

    // Defining function modifier 'instate'
    public fun instate(expected_state: State) {
        require(state == expected_state);
    }

    // Defining function modifier 'onlyBuyer'
    public fun onlyBuyer() {
        require(msg.sender == buyer || msg.sender == arbiter);
    }

    // Defining function modifier 'onlySeller'
    public fun onlySeller() {
        require(msg.sender == seller);
    }

    // Defining a constructor
    public fun init(_buyer: address payable, _sender: address payable) {
        arbiter = move(sender);
        buyer = _buyer;
        seller = _sender;
        state = AWAIT_PAYMENT;
    }

    // Defining function to confirm payment
    public fun confirm_payment() {
        instate(AWAIT_PAYMENT);
        onlyBuyer();
        state = AWAIT_DELIVERY;
    }

    // Defining function to confirm delivery
    public fun confirm_delivery() {
        instate(AWAIT_DELIVERY);
        onlyBuyer();
        seller.move_to(address(this).balance);
        state = COMPLETE;
    }

    // Defining function to return payment
    public fun return_payment() {
        instate(AWAIT_DELIVERY);
        onlySeller();
        buyer.move_to(address(this).balance);
    }
}
