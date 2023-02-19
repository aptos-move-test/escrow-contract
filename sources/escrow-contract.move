module Escrow {

    // Declaring the state variables
    address payable buyer;
    address payable seller;
    address payable arbiter;
    map<Address, u64> TotalAmount;

    // Defining a Type
    type State = u64;

    // Following are the data members of the State
    const AWAIT_PAYMENT: State = 1;
    const AWAIT_DELIVERY: State = 2;
    const COMPLETE: State = 3;

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
