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

@external
def withdraw(amount: uint256):
    self.balances[msg.sender] -= amount
    cut: uint256 = amount * self.fee_bps // 10000
    send(msg.sender, amount - cut)

@external
def set_fee(f: uint256):
    assert msg.sender == self.owner
    assert f <= 1000
    self.fee_bps = f
