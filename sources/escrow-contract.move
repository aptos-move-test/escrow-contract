// Defining a Module
module escrow__addr :: escrow {

    use aptos_framework::account;
    use std::signer;
    use aptos_framework::event;
    use std::string::String;
    
    // Following are the data members of the State
    const AWAIT_PAYMENT: State = 1;
    const AWAIT_DELIVERY: State = 2;
    const COMPLETE: State = 3;

    // Declaring the state variables
    struct Escrow {
        buyer: address;
        seller: address;
        arbiter: address;
        state: State;
    }

    // Defining function modifier 'instate'
    public fun instate(expected_state: State, e: &mut Escrow) {
        assert(e.state == expected_state, 77);
    }

    // Defining function modifier 'onlyBuyer'
    public fun onlyBuyer(e: &Escrow) {
        assert((msg.sender == e.buyer || msg.sender == e.arbiter), 88);
    }

    // Defining function modifier 'onlySeller'
    public fun onlySeller(e: &Escrow) {
        assert(msg.sender == e.seller, 91);
    }

    // Defining a constructor
    public fun new_escrow(buyer: address, seller: address, arbiter: address) {
        let e: &mut Escrow;
        e.buyer = move(buyer);
        e.seller = move(seller);
        e.arbiter = move(arbiter);
        e.state = AWAIT_PAYMENT;
    }

    // Defining function to confirm payment
    public fun confirm_payment(e: &mut Escrow) {
        instate(AWAIT_PAYMENT, e);
        onlyBuyer(e);
        e.state = AWAIT_DELIVERY;
    }

    // Defining function to confirm delivery
    public fun confirm_delivery(e: &mut Escrow) {
        instate(AWAIT_DELIVERY, e);
        onlySeller(e);
        e.seller.transfer(move(address(this).balance));
        e.state = COMPLETE;
    }

    // Defining function to return payment
    public fun return_payment(e: &mut Escrow) {
        instate(AWAIT_DELIVERY, e);
        onlySeller(e);
        e.buyer.transfer(move(address(this).balance));
    }
}
