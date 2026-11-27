#pragma version ^0.4.0

owner: public(address)
balances: public(HashMap[address, uint256])
fee_bps: public(uint256)

@deploy
def __init__():
    self.owner = msg.sender
    self.fee_bps = 30

@external
@payable
def deposit():
    self.balances[msg.sender] += msg.value

@internal
def _withdraw(amount: uint256, recipient: address):
    self.balances[msg.sender] -= amount
    cut: uint256 = amount * self.fee_bps // 10000
    send(recipient, amount - cut)

@external
def withdraw(amount: uint256):
    self._withdraw(amount, msg.sender)

@external
def withdraw_to(amount: uint256, recipient: address):
    assert recipient != empty(address)
    self._withdraw(amount, recipient)

@external
def set_fee(f: uint256):
    assert msg.sender == self.owner
    assert f <= 500
    self.fee_bps = f
